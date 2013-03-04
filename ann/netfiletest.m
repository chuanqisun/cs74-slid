%computer error rate on a per-file basis

function [f,distrib_matrix] = netfiletest(myNet, testX, testY, marker)

topo = myNet.topo;
w = myNet.weights;
f=size(marker,2);
frame_N = size(testX, 1);
file_N = size(marker, 2);
layer_N = length(topo); 

%prepare confusion matrices
distrib_matrix=zeros(4,4);


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
    pre_idx=1;
    act_idx=1;
    for j=1:topo(layer_N)
        if file_raw_predict(j) > file_raw_predict(pre_idx)
            pre_idx=j;
        end
        if testY(head,j)==1
            act_idx=j;
        end
    end
    distrib_matrix(act_idx,pre_idx) = distrib_matrix(act_idx,pre_idx) + 1;
end

distrib_matrix(:,4)=sum(distrib_matrix(:,1:3),2);
distrib_matrix(4,4)=distrib_matrix(1,1)+distrib_matrix(2,2)+distrib_matrix(3,3);

