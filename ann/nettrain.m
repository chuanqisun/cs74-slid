%% train network
% trainX  trainsetX
% trainY  trainsetY
% topo    topology [input_layer_size, ... , output_layer_size]
% max_epoch maximum epoch to train
% l_rate learning rate
% lambda regulation term
% fail_threshold #of epochs allowed after mse starts increasing
% convergence_mes mes to stop training
% k for k-fold validation

function myNet = nettrain(train_data,test_data,topo,max_epoch,l_rate,lambda,fail_threshold,convergence_mse,k)

%flag for plotting legend
legendset=0;

%return structure of network
myNet.topo = topo;

%set constants for topology and input/output
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
train_error_list=[];
validation_error_list=[];
frame_test_error_list=[];
file_test_error_list=[];
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

min_mse=Inf;
fail_count=0;
mse = Inf;
epochs = 0;

while mse > convergence_mse && epochs < max_epoch && fail_count < fail_threshold

  
    
    %reset avg delta_weights        
    for i = 1:layer_N-1
        avg_delta_weights{i} = zeros(topo(i+1), topo(i)+1);
    end   
    
    %reset error rates
    validation_error_rate = 0;
    train_error_rate = 0;
    
    %for each fold feedforwad, backprop, and compute error
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
        ms_sum = sum(sum(error_out.^2));


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
        
        %update weights (temporary)
        for i = 1:layer_N-1
            old_weights{i}(end)=0;
            temp_weights{i} = weights{i} + delta_weights{i} ./sample_N + lambda*old_weights{i};
  
        end    
        myNet.weights = temp_weights;
     
        %compute current error rate
    	output = nettest(validX,myNet);
        validation_error_rate = validation_error_rate + calculate_error_rate(output, validY);
        output = nettest(trainX,myNet);
        train_error_rate = train_error_rate + calculate_error_rate(output, trainY);
    end

    
    %adjust weights with avg delta
    for i = 1:layer_N-1
        weights{i} = weights{i} + avg_delta_weights{i}/(k*sample_N) + lambda*old_weights{i};
    end    
    old_weights=weights;
    myNet.weights = weights;
    
    %compute test error based on frames
    output = nettest(testX,myNet);
    frame_test_error_rate = calculate_error_rate(output, testY);
    frame_test_error_list=[frame_test_error_list, frame_test_error_rate];
    
    %computer test error rate based on files;
    [error1,c1]=netfiletest(myNet,en_testX,en_testY,en_marker);
    [error2,c2]=netfiletest(myNet,fr_testX,fr_testY,fr_marker);
    [error3,c3]=netfiletest(myNet,ge_testX,ge_testY,ge_marker);
    file_test_error_rate=(c1+c2+c3)/sum(test_data.file_count);
    file_test_error_list=[file_test_error_list,file_test_error_rate];
    
    validation_error_list=[validation_error_list, validation_error_rate/k];
    train_error_list=[train_error_list, train_error_rate/k];  
    epoch_list=[epoch_list, epochs];
    
    %plot

    if epochs <= 100
        p1=plot(epoch_list, validation_error_list, 'r', 'LineWidth',2);  
        hold all;
        p2=plot(epoch_list, train_error_list, 'b', 'LineWidth',2);
        p3=plot(epoch_list, frame_test_error_list, 'g', 'LineWidth',2);
        p4=plot(epoch_list, file_test_error_list, 'y', 'LineWidth',2);
    else
        hold all;
        p1=plot(epoch_list(epochs-100:epochs), validation_error_list(epochs-100:epochs), 'r', 'LineWidth',2);  
        p2=plot(epoch_list(epochs-100:epochs), train_error_list(epochs-100:epochs), 'b', 'LineWidth',2);
        p3=plot(epoch_list(epochs-100:epochs), frame_test_error_list(epochs-100:epochs), 'g', 'LineWidth',2);
        p4=plot(epoch_list(epochs-100:epochs), file_test_error_list(epochs-100:epochs), 'y', 'LineWidth',2);
    end
    if legendset==0
        legendset=1;
        hleg1 = legend([p1, p2, p3, p4], 'Validation','Training','Frame Test','File Test');
        legend(hleg1, 'Location', 'NorthEastOutside');
        title('Performance');
        xlabel('epoch');
        ylabel('error rate');
    end
    
    %flush buffer
    if mod(epochs,100)==0
        clf;
        legendset=0;
    end

    drawnow;
    
    disp('epoch: ');
    disp(epochs);
    %update epoch
    epochs = epochs +1;
    disp('train MSE: ');  
    mse = ms_sum/(sample_N*size(trainY, 2));
    if mse<min_mse
        min_mse=mse;
        fail_count=0;
    else
        fail_count = fail_count+1;
    end
    disp(mse);
    
    

end

%output summary

close all;
p1=plot(epoch_list, validation_error_list, 'r');  
hold all;
p2=plot(epoch_list, train_error_list, 'b');
p3=plot(epoch_list, frame_test_error_list, 'g');
p4=plot(epoch_list, file_test_error_list, 'y');
set(p1,'Color','red','LineWidth',2);
set(p2,'Color','blue','LineWidth',2);
set(p3,'Color','green','LineWidth',2);
set(p4,'Color','yellow','LineWidth',2);
hleg1 = legend([p1, p2, p3, p4], 'Validation','Training','Frame Test','File Test');
legend(hleg1, 'Location', 'NorthEastOutside');
title('Performance');
xlabel('epoch');
ylabel('error rate');

s1=strcat('total epochs: ',num2str(epochs));
s2=strcat('mse performance: ',num2str(min_mse));
s3=strcat('english file error: ',num2str(error1));
s4=strcat('french file error: ',num2str(error2));
s5=strcat('germen file error: ',num2str(error3));
s6=strcat('training error: ',num2str(train_error_rate/k));
s7=strcat('validation error: ',num2str(validation_error_rate/k));
s8=strcat('frame test error: ',num2str(frame_test_error_rate));
s9=strcat('file test error: ',num2str(file_test_error_rate));
disp(s1);
disp(s2);
disp(s3);
disp(s4);
disp(s5);
disp(s6);
disp(s7);
disp(s8);
disp(s9);