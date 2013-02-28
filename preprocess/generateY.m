function [Y]= generateY(X,label)

%given a label, generate Y matching X
Y=ones(size(label,1),size(X,2));

for row=1:size(label,1)
    Y(row,:) = Y(row,:) * label(row, 1);
end