%% train network
% trainX  trainsetX
% trainY  trainsetY
% topo    topology [input_layer_size, ... , output_layer_size]
% max_epoch maximum epoch to train
% l_rate learning rate
% convergence_mes mes to stop training
% k for k-fold validation

function myNet = nettrain(trainX,trainY,topo,max_epoch,l_rate,convergence_mse,k)

%flag for plotting legend
legendset=0;

%return structure of network
myNet.topo = topo;

%set constants for topology and input/output
trainX = trainX';
trainY = trainY';

%prepare error rate array against epoch list
train_error_list=[];
validation_error_list=[];
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

%allocate space for y, input signal of each layer.  first layer is input,
%the hidden layers are sigmoided values plus a bias value. The output layer
%has no bias node.
y = cell(layer_N, 1);


for i = 2:layer_N-1
    y{i} = cat(2, zeros(sample_N, topo(i)), ones(sample_N, 1));
end
y{layer_N}= zeros(sample_N, topo(layer_N));


mse = Inf;
epochs = 0;

while mse > convergence_mse && epochs < max_epoch

  
    
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
            temp_weights{i} = weights{i} + delta_weights{i} ./sample_N;
        end    
        myNet.weights = temp_weights;        
     
        %compute current error rate
    	output = nettest(validX,myNet);
        validation_error_rate = validation_error_rate + calculate_error_rate(output, validY);
        output = nettest(trainX,myNet);
        train_error_rate = train_error_rate + calculate_error_rate(output, trainY);
    end
    
    %compute avg delta weights across all folds
    for i = 1:layer_N-1
        avg_delta_weights{i} = avg_delta_weights{i}/k;
    end     

    
    %adjust weights with avg delta
    for i = 1:layer_N-1
        weights{i} = weights{i} + avg_delta_weights{i} ./sample_N;
    end    
    myNet.weights = weights;
    
    
    
    disp('epoch: ');
    disp(epochs);
    
    validation_error_list=[validation_error_list, validation_error_rate/k];
    train_error_list=[train_error_list, train_error_rate/k];
    disp('validation error: ');
    disp(validation_error_rate/k);
    disp('train error: ');    
    disp(train_error_rate/k);    
    epoch_list=[epoch_list, epochs];
    
    %plot

    p1=plot(epoch_list, validation_error_list, 'r');  
    hold all;
    p2=plot(epoch_list, train_error_list, 'b');
    
    if legendset==0
        legendset=1;
        set(p1,'Color','red','LineWidth',2);
        set(p2,'Color','blue','LineWidth',2);
        hleg1 = legend([p1, p2], 'Validation','Training');
        legend(hleg1, 'Location', 'NorthEast');
        title('Performance');
        xlabel('epoch');
        ylabel('error rate');
    end

    drawnow;
    
    %update epoch
    epochs = epochs +1;
    disp('train MSE: ');  
    mse = ms_sum/(sample_N*size(trainY, 2));
    disp(mse);

                    
end


