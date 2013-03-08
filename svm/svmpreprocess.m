%preprocess train and test data for SVM
%Input:
%   train_data -- train data struct
%   test_data  -- test data struct
%   degree     -- degree of poly kernel
%Return:
%   trainX     -- parsed X matrix for training
%   xxvsallY   -- Y matrix for language xx versus all
%   testX     -- parsed X matrix for testing
%   testY     -- parsed Y matrix for testing
%   kernel_matrix -- polynomial kernel matrix computed using the given degree

function [trainX,envsallY,frvsallY,gevsallY,testX,testY,kernel_matrix]=svmpreprocess(train_data,test_data,degree)
    encount=train_data.frame_count(1);
    frcount=train_data.frame_count(2);
    gecount=train_data.frame_count(3);
    trainX=cat(2, train_data.en_X, train_data.fr_X, train_data.ge_X)';
    envsallY=[ones(encount,1);-1*ones(frcount,1);-1*ones(gecount,1)];
    frvsallY=[-1*ones(encount,1);ones(frcount,1);-1*ones(gecount,1)];
    gevsallY=[-1*ones(encount,1);-1*ones(frcount,1);ones(gecount,1)];
    
    kernel_matrix=kernel(trainX,degree);
    
    testX=cat(2,test_data.en_X,test_data.fr_X,test_data.ge_X)';
    testY=cat(2,test_data.en_Y,test_data.fr_Y,test_data.ge_Y)';
end