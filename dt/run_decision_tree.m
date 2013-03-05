function [ results, raw ] = run_decision_tree( X, Y, tree )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

X = X';
Y = Y';

results = zeros(size(X, 1), 3);
raw = zeros(size(X, 1), 3);
for i = 1:1:size(X, 1)
slot = 1;
    while(tree(slot, 1) ~= 0)
        tree(slot, 1);
        div = tree(slot, 4);
        if(X(i, tree(slot, 1)) >= div)
            slot = tree(slot, 2);
        else
            slot = tree(slot, 3);
        end
    end

    if tree(slot, 2) == 1
        results(i, :) = [1 0 0];
    elseif tree(slot, 2) == 2
        results(i, :) = [0 1 0];
    else
        results(i, :) = [0 0 1];
    end
    
    raw(i, 1) = tree(slot, 3);
    raw(i, 2) = tree(slot, 4);
    raw(i, 3) = 1-raw(i, 1) - raw(i, 2);

end

error_count = 0;
error_bool = 0;
%
for i = 1: size(Y, 1)
    error_row = Y(i, :) - results(i, :);

    for j = 1: size(Y, 2)
        if error_row(1, j) ~= 0
            error_bool = 1;
        end
    end
    if error_bool ~= 0
        error_count = error_count +1;
    end
    error_bool = 0;
end

error_rate = error_count/size(Y, 1);

