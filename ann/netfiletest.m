%computer error rate on a per-file basis

function [file_error_rate, file_error_count] = netfiletest(myNet, testX, testY, marker)

topo = myNet.topo;
w = myNet.weights;

frame_N = size(testX, 1);
file_N = size(marker, 2);
layer_N = length(topo); 



%allocate space for out, raw output value of each layer.  naturally there
%is no out feeding into the input layer
out = cell(layer_N-1, 1);
for i = 1:layer_N-1
    out{i} = zeros(frame_N, topo(i+1));
end

%allocate space for y, input signal of each layer.  first layer is input,
%the hidden layers are sigmoided values plus a bias value. The output layer
%has no bias node.
y = cell(layer_N, 1);

y{1} = cat(2, testX, ones(frame_N, 1));
for i = 2:layer_N-1
    y{i} = cat(2, zeros(frame_N, topo(i)), ones(frame_N, 1));
end
y{layer_N}= zeros(frame_N, topo(layer_N));


% Get the output at the output layer
for i = 1:layer_N-1
    out{i} = y{i} * w{i}';
    y{i+1}(:, 1:topo(i+1)) = 1 ./ (1 + exp(-out{i}));
end

% Get accumulated output for each file
error_count=0;
for i = 1:file_N
    head=marker(1,i);
    tail=marker(2,i);
    file_raw_predict=sum(y{layer_N}(head:tail,:),1);
    max_idx=1;
    for j=1:topo(layer_N)
        if file_raw_predict(j) > file_raw_predict(max_idx)
            max_idx=j;
        end
    end
    if testY(head,max_idx)~=1
        error_count=error_count+1;
    end
end
file_error_count=error_count;
file_error_rate=error_count/file_N;



