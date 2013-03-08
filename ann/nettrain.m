% train network
% Input:
%     trainX            -- trainsetX
%     trainY            -- trainsetY
%     topo              -- topology [input_layer_size, ... , output_layer_size]
%     max_epoch         -- maximum epoch to train
%     l_rate            -- learning rate
%     lambda            -- regulation term
%     fail_threshold    -- #of epochs allowed after mse starts increasing
%     convergence_mes   -- mes to stop training
%     k                 -- k for k-fold validation
% Return:
%     result -- struct containing the following fields
%           f1: the network struct
%           f2: epochs before termination
%           f3: min square error
%           f4: per file test confusion matrix w.r.t. file count
%           f5: per file test confusion matrix w.r.t. percentage
%           f6: per frame test confustion matrix w.r.t frame count
%           f7: per frame test confusion matrix w.r.t percentage
%           f8: per frame training error rate
%           f9: per frame validation error rate
%           f10: per frame test error rate
%           f11: array of epochs (used for plot)
%           f12: array of training mse for each epoch
%           f13: array of validation mse for each epoch
%           f14: array of frame test mse for each epoch
%     fig -- a plot of f11,f12,f13 against f11
function [result,fig] = nettrain(train_data,test_data,topo,max_epoch,l_rate,lambda,fail_threshold,convergence_mse,k)

    %flag for plotting legend
    legendset=0;

    %parse parameters
    myNet.topo = topo;

    trainX = cat(2,train_data.en_X,train_data.fr_X,train_data.ge_X)';
    trainY = cat(2,train_data.en_Y,train_data.fr_Y,train_data.ge_Y)';

    en_testX=test_data.en_X';
    fr_testX=test_data.fr_X';
    ge_testX=test_data.ge_X';

    en_testY=test_data.en_Y';
    fr_testY=test_data.fr_Y';
    ge_testY=test_data.ge_Y';

    testX = cat(1, en_testX,fr_testX,ge_testX);
    testY = cat(1, en_testY,fr_testY,ge_testY);

    en_marker=test_data.en_marker;
    fr_marker=test_data.fr_marker;
    ge_marker=test_data.ge_marker;

    %prepare error rate array against epoch list
    train_mse_list=[];
    validation_mse_list=[];
    frame_test_mse_list=[];
    epoch_list=[];

    %split into kfold
    [kfoldX, kfoldY, sample_N] = split(trainX, trainY, k);

    layer_N = size(topo, 2);

    weights = cell(layer_N-1,1); 

    for i=2:layer_N-2        
        weights{i} = rand(topo(i+1),topo(i)+1)*2 -1;
    end

    %assign a random number to each weight first
    weights{1} = rand(topo(2), topo(1)+1)*2 -1;
    weights{layer_N-1} = rand(topo(layer_N), topo(layer_N-1)+1)*2-1;
    myNet.weights = weights;

    %allocate space for delta_weight, the sum of delta weights of all samples
    delta_weights = cell(layer_N-1, 1);
    avg_delta_weights= cell(layer_N-1, 1);
    temp_weights= cell(layer_N-1, 1);

    for i = 1:layer_N-1
        delta_weights{i} = zeros(topo(i+1), topo(i)+1);
        temp_weights{i} = zeros(topo(i+1), topo(i)+1);
        avg_delta_weights{i} = zeros(topo(i+1), topo(i)+1);
    end

    %allocate space for out, raw output value of each layer.  naturally there
    %is no out feeding into the input layer
    out = cell(layer_N-1, 1);
    for i = 1:layer_N-1
        out{i} = zeros(sample_N, topo(i+1));
    end

    %allocate space for regulation term
    old_weights = cell(layer_N-1,1);
    for i=1:layer_N-1
        old_weights{i} = zeros(topo(i+1), topo(i)+1);
    end

    %allocate space for y, input signal of each layer.  first layer is input,
    %the hidden layers are sigmoided values plus a bias value. The output layer
    %has no bias node.
    y = cell(layer_N, 1);


    for i = 2:layer_N-1
        y{i} = cat(2, zeros(sample_N, topo(i)), ones(sample_N, 1));
    end
    y{layer_N}= zeros(sample_N, topo(layer_N));

    %prepare for main loop
    min_mse=Inf;
    fail_count=0;
    mse = Inf;
    epochs = 0;

    %main loop
    while mse > convergence_mse && epochs < max_epoch && fail_count < fail_threshold

        %reset avg delta_weights        
        for i = 1:layer_N-1
            avg_delta_weights{i} = zeros(topo(i+1), topo(i)+1);
        end   

        %reset error rates
        validation_mse = 0;
        train_mse = 0;

        %for each fold feedforwad, backprop, and compute error
        for f=1:k
            %construct validation set just for this fold
            validX=kfoldX{f};
            validY=kfoldY{f};

            %construct trainset
            trainX=[];
            trainY=[];
            for ff=1:k
                if f~=ff
                    trainX=cat(1,trainX, kfoldX{ff});
                    trainY=cat(1,trainY, kfoldY{ff});
                end
            end 

            sample_N = size(trainX,1);

            %set input layer for this training set
            y{1} = cat(2, trainX, ones(sample_N, 1));

            %feedforward
            for i = 1:layer_N-1
                out{i} = y{i} * weights{i}';
                y{i+1}(:, 1:topo(i+1)) = 1./(1 + exp(-out{i}));
            end    

            %error at the output layer
            error_out = (trainY-y{layer_N});

            %output error * derivative of the sigmoid function
            D = error_out.* y{layer_N}.*(1- y{layer_N});

            %backpropagate error starting at the last hidden layer's weight matrix
            for i = layer_N-1: -1: 1
                delta_weights{i} = l_rate * D(:, 1:topo(i+1))' * y{i};
                avg_delta_weights{i}=avg_delta_weights{i} + delta_weights{i};

                %update D
                if i ~= 1
                    D = (D(:, 1:topo(i+1)) * weights{i}).* y{i}.*(1-y{i});
                end
            end

            %update weights (temporary, just for this fold)
            for i = 1:layer_N-1
                old_weights{i}(end)=0;
                temp_weights{i} = weights{i} + delta_weights{i} ./sample_N + lambda*old_weights{i};

            end    
            myNet.weights = temp_weights;

            %compute current mse, just for this fold
            [output,raw_output,mse] = nettest(myNet,validX,validY);
            validation_mse = validation_mse + mse;
            [output,raw_output,mse] = nettest(myNet,trainX,trainY);
            train_mse = train_mse + mse;
        end


        %adjust weights with avg delta, permanently, using average across k
        %folds
        for i = 1:layer_N-1
            weights{i} = weights{i} + avg_delta_weights{i}/(k*sample_N) + lambda*old_weights{i};
        end    
        old_weights=weights;
        myNet.weights = weights;

        %compute test error based on frames
        [output, raw_output,frame_test_mse] = nettest(myNet,testX,testY);
        frame_test_mse_list=[frame_test_mse_list, frame_test_mse];

        %computer test error rate based on files;
        validation_mse_list=[validation_mse_list, validation_mse/k];
        train_mse_list=[train_mse_list, train_mse/k];  
        epoch_list=[epoch_list, epochs];

        %plot -- the plot refreshes dynamically after the first 100 epochs
        if epochs <= 100
            p1=plot(epoch_list, validation_mse_list, 'r', 'LineWidth',2);  
            hold all;
            p2=plot(epoch_list, train_mse_list, 'b', 'LineWidth',2);
            p3=plot(epoch_list, frame_test_mse_list, 'g', 'LineWidth',2);
        else
            hold all;
            p1=plot(epoch_list(epochs-100:epochs), validation_mse_list(epochs-100:epochs), 'r', 'LineWidth',2);  
            p2=plot(epoch_list(epochs-100:epochs), train_mse_list(epochs-100:epochs), 'b', 'LineWidth',2);
            p3=plot(epoch_list(epochs-100:epochs), frame_test_mse_list(epochs-100:epochs), 'g', 'LineWidth',2);
        end
        if legendset==0
            legendset=1;
            hleg1 = legend([p1, p2, p3], 'Validation','Training','Test');
            legend(hleg1, 'Location', 'NorthEastOutside');
            title('Performance');
            xlabel('epoch');
            ylabel('MSE');
        end

        %flush buffer
        if mod(epochs,100)==0
            clf;
            legendset=0;
        end

        drawnow;

        disp('epoch: ');
        disp(epochs);

        %update epoch and terminate conditions
        epochs = epochs +1;
        disp('train MSE: ');  
        train_mse = train_mse/k;
        validation_mse = validation_mse/k;

        if validation_mse<min_mse
            min_mse=validation_mse;
            fail_count=0;
        else
            fail_count = fail_count+1;
        end
        disp(train_mse);


    end

    %---------------after training----------------

    %measure error rate

    %frame test error rate
    [output,raw_output,frame_test_mse] = nettest(myNet,testX,testY);
    [frame_test_error_rate, frame_test_distrib_matrix, frame_test_correct_matrix] = calculate_error_rate(output, testY);

    %file test confusion matrix
    [en_f,en_distrib_matrix]=netfiletest(myNet,en_testX,en_testY,en_marker);
    [fr_f,fr_distrib_matrix]=netfiletest(myNet,fr_testX,fr_testY,fr_marker);
    [ge_f,ge_distrib_matrix]=netfiletest(myNet,ge_testX,ge_testY,ge_marker);
    file_distrib_matrix=en_distrib_matrix+fr_distrib_matrix+ge_distrib_matrix;

    file_correct_matrix=zeros(4);
    f=en_f+fr_f+ge_f;
    for i=1:3
        for j=1:3
            file_correct_matrix(i,j)=file_distrib_matrix(i,j)/f;
        end
    end

    file_correct_matrix(4,4)=file_distrib_matrix(4,4)/f;
    for j=1:3
        file_correct_matrix(j,4)=file_distrib_matrix(j,j)/file_distrib_matrix(j,4);
    end



    %training error rate and validation error rate, based on k-fold
    validation_error_rate=0;
    train_error_rate=0;
    for f=1:k
        %construct validation set
        validX=kfoldX{f};
        validY=kfoldY{f};

        %construct trainset
        trainX=[];
        trainY=[];
        for ff=1:k
            if f~=ff
                trainX=cat(1,trainX, kfoldX{ff});
                trainY=cat(1,trainY, kfoldY{ff});
            end
        end 
        output = nettest(myNet,validX,validY);
        validation_error_rate = validation_error_rate + calculate_error_rate(output, validY);
        output = nettest(myNet,trainX,trainY);
        train_error_rate = train_error_rate + calculate_error_rate(output, trainY);    

    end

    validation_error_rate=validation_error_rate/k;
    train_error_rate=train_error_rate/k;



    %output summary plot and store everything in struct
    close all;
    fig=figure();
    p1=plot(epoch_list, validation_mse_list, 'r');  
    hold all;
    p2=plot(epoch_list, train_mse_list, 'b');
    p3=plot(epoch_list, frame_test_mse_list, 'g');
    set(p1,'Color','red','LineWidth',2);
    set(p2,'Color','blue','LineWidth',2);
    set(p3,'Color','green','LineWidth',2);
    hleg1 = legend([p1, p2, p3], 'Validation','Training','Test');
    legend(hleg1, 'Location', 'NorthEastOutside');
    title('Performance');
    xlabel('epoch');
    ylabel('error rate');

    f1='network';
    v1=myNet;
    f2='total_epochs';
    v2=epochs;
    f3='mse_performance';
    v3=min_mse;
    f4='file_confusion_count_matrix';
    v4=file_distrib_matrix;
    f5='file_confusion_rate_matrix';
    v5=file_correct_matrix;
    f6='test_frame_confusion_count_matrix';
    v6=frame_test_distrib_matrix;
    f7='test_frame_confusion_rate_matrix';
    v7=frame_test_correct_matrix;
    f8='train_error_rate';
    v8=train_error_rate;
    f9='validation_error_rate';
    v9=validation_error_rate;
    f10='frame_test_error_rate';
    v10=1-frame_test_correct_matrix(4,4);
    f11='epoch_list';
    v11=epoch_list;
    f12='train_mse_list';
    v12=train_mse_list;
    f13='validation_mse_list';
    v13=validation_mse_list;
    f14='frame_test_mse_list';
    v14=frame_test_mse_list;
    result=struct(f1,v1,f2,v2,f3,v3,f4,v4,f5,v5,f6,v6,f7,v7,f8,v8,f9,v9,f10,v10,f11,v11,f12,v12,f13,v13,f14,v14);
end