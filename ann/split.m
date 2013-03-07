%breakdown training set into k fold
%Input: trainX -- training set X
%       trainY -- training set Y
%       k -- number of folds
%Return:
%       kfoldX -- cell array containing each fold of X
%       kfoldY -- cell array containing each fold of Y
%       trainsize -- size of training set = N(k-1)/k
function [kfoldX, kfoldY, trainsize] = split(trainX, trainY, k)
    kfoldX=cell(1,k);
    kfoldY=cell(1,k);
    %randomize index
    sample_count=size(trainX,1);
    randidx=randperm(sample_count);
    
    splitidx=[];
    splitgap=floor(sample_count/k);
    trainsize=(k-1)*splitgap;
    for i=0:k
        splitidx=[splitidx, 1 + i*splitgap];
    end
    
    for i=1:k
        kfoldX{i}=zeros(splitidx(i+1)-splitidx(i), size(trainX,2));
        kidx=0;
        for j=splitidx(i):splitidx(i+1)-1
            kidx=kidx+1;
            kfoldX{i}(kidx,:)=trainX(randidx(j),:);
            kfoldY{i}(kidx,:)=trainY(randidx(j),:);
        end
    end
end
    
    
            