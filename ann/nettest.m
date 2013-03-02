function [output,raw_output,mse] = nettest(myNet,testX,testY)
%get input/output and constants
sample_N = size(testX, 1);

topo = myNet.topo;
w = myNet.weights;
layer_N = length(topo); 



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

y{1} = cat(2, testX, ones(sample_N, 1));
for i = 2:layer_N-1
    y{i} = cat(2, zeros(sample_N, topo(i)), ones(sample_N, 1));
end
y{layer_N}= zeros(sample_N, topo(layer_N));


% Get the output at the output layer
for i = 1:layer_N-1
    out{i} = y{i} * w{i}';
    y{i+1}(:, 1:topo(i+1)) = 1 ./ (1 + exp(-out{i}));
end
    
    
%format raw output to 0 and 1 values.
raw_output = y{layer_N};

%compute mse

error_out = (testY-raw_output);
ms_sum = sum(sum(error_out.^2));
mse = ms_sum/(sample_N*size(testY, 2));

%compute prediction matrix
output = zeros(sample_N, size(raw_output, 2));
    
for p = 1:sample_N
    max_col = 1;
    for i = 1: size(output, 2)
        if raw_output(p, i) >= raw_output(p, max_col)
            max_col = i;
        end
    end
        
    for i = 1: size(output, 2)
        if i == max_col
            output(p, i) = 1;
        else
            output(p, i) = 0;
        end
    end
        
end
