% Template
function [ new_tree, new_slot ] = DT_recursive2(X, Y, feat_idx, tree, slot, c)

%DT_RECURSIVE A recursive decision tree algorithm
% This function calculates the sub tree of the whole decision tree rooted 
% at the current splitting node

%   X  Txd  the traing samples that fall to the current splitting node (binary)   
%   Y  Tx1  the labels for X (binary)
%   feat_idx Rx1(R<=d) idx for features that can be used by this current 
%                      splitting node 
%   tree Qx3 the tree matrix (see. DecisionTree.m) holding all the part 
%            of the tree that is already calculated
%   slot 1x1 the row number pointing to the next unused row in the tree matrix
%   c 1x1 the max size for a leaf
%
%   Return
%   new_tree Sx3 (S>=Q+1) holding all previous parts in the tree matrix
%                         and the sub-tree rooting at the current splitting 
%                         node.
%   new_slot 1x1 the row number of the next unused row in new_tree


%% Termination condition

N = size(Y, 1);
if (N <= c || size(feat_idx, 2) == 0)
    %todo: YOUR IMPLEMENTATION HERE:% termination condition matches (this node is a leaf node).
    new_tree = tree;
    % create a new row in new_tree(slot, :), and fill in this row.
    %   If s1==0, this row is a leaf:
%   s1 is always 0.
%   s2 is the label for the leaf (either 0 or 1).
%   s3 is p(y=1|x is in this leaf) for this decision leaf.
    % todo: YOUR IMPLEMENTATION HERE
    % Return new_tree and new_slot, which is slot+1;

    s1 = 0;

    
    p1 = sum(Y(:, 1))/size(Y, 1); %fraction of English files
    p2 = sum(Y(:, 2))/size(Y, 1); %fraction of French files
    p3 = 1-p1-p2; %fraction of German files

    if p1>=p2 && p1>=p3
        s2 = 1;
    elseif p2>=p3
        s2 = 2;
    else
        s2 = 3;
    end  
        
    s3 = p1;
    s4 = p2;
    new_tree(slot, :) = [s1, s2, s3, s4];
    new_slot = slot+1;    

    return
end

%% Find the best split given a randomly selected feature

% calculate the entropy impurity measurements for all the features that 
% are in feat_idx, and find the best splitting feature that decreases the 
% impurity most. Assign this feature to feat_selected


feature_N = size(feat_idx, 2);
size_Y = size(Y, 1);


best_feature_entropy = Inf;
best_feature_div_point = 0;
best_feat_index = 0;
for feat_index = 1:feature_N

    feat_index
    %find best dividing point for this feature
    feat_min_val = min(X(:, feat_index));
    feat_max_val = max(X(:, feat_index));
    range = feat_max_val - feat_min_val;
    best_div_point = 0;
    best_entropy = Inf;
    
    for div_point = feat_min_val : (range/20) : feat_max_val
        Ybelowcount = 0;
        Yabovecount = 0;
        subYbelowdiv = zeros(size_Y, 3);
        subYabovediv = zeros(size_Y, 3);

        for j = 1: 1: size(X, 1)
            if X(j, feat_index) >= div_point
                Yabovecount = Yabovecount+1;
                subYabovediv(Yabovecount, :) = Y(j, :);
            else
                Ybelowcount = Ybelowcount +1;
                subYbelowdiv(Ybelowcount, :) = Y(j, :);
            end
        end

            subYabovediv = subYabovediv(1:Yabovecount, :);
            subYbelowdiv = subYbelowdiv(1:Ybelowcount, :);

            above_div_entropy = get_impurity(subYabovediv);
            below_div_entropy = get_impurity(subYbelowdiv);

           % old_entropy = get_impurity(Y);

            if(Yabovecount == 0)
                above_div_entropy = 0;
            end
            if(Ybelowcount == 0)
                below_div_entropy = 0;
            end
            total_new_entropy = above_div_entropy * Yabovecount/size_Y + below_div_entropy * Ybelowcount/size_Y;
        
        if total_new_entropy <= best_entropy
            best_entropy = total_new_entropy;
            best_div_point = div_point;
        end

    end
    
    if best_entropy <= best_feature_entropy
        best_feature_entropy = best_entropy;
        best_feature_div_point = best_div_point;
        best_feat_index = feat_index;
    end
        
end
        
        

%feat_selected = best_feature(1, 1);


% todo: YOUR IMPLEMENTATION HERE
feat_selected = feat_idx(1, best_feat_index);


%% Create a new splitting node and recursively (NO IMPLEMENTATION NEEDED)
% creating this new node
tree(slot, 1) = feat_selected;
tree(slot, 4) = best_feature_div_point;
% since this feat is used in this split, it is not feasible to use this
% feature again in children nodes.
feat_idx = feat_idx(feat_idx ~= feat_selected);
% recursively calculating its left child tree

tree(slot, 2) = slot+1;

[tree, new_slot] = DT_recursive2(X(X(:, feat_selected)>=best_feature_div_point, :), Y(X(:, feat_selected)>=best_feature_div_point, :), ...
    feat_idx, tree, slot+1, c);
tree(slot, 3) = new_slot;
% recursively calculating its right child tree  

[new_tree, new_slot] = DT_recursive2(X(X(:, feat_selected)<best_feature_div_point, :), Y(X(:, feat_selected)<best_feature_div_point, :), ...
    feat_idx, tree, new_slot, c);
return;

end


