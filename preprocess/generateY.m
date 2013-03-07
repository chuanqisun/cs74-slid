%generate Y vector from X and given label
%Input:
%   X -- X in the training set
%   label -- label corresponding to the X
%Return:
%   Y -- Y matrix compatible with training data format
function [Y]= generateY(X,label)

%given a label, generate Y matching X
Y=ones(size(label,1),size(X,2));

for row=1:size(label,1)
    Y(row,:) = Y(row,:) * label(row, 1);
end