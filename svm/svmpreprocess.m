%preprocess the train data for three SVM's

function [trainX,envsallY, frvsallY, gevsallY]=svmpreprocess(train_data)
    encount=train_data.frame_count(1);
    frcount=train_data.frame_count(2);
    gecount=train_data.frame_count(3);
    trainX=cat(2, train_data.en_X, train_data.fr_X, train_data.ge_X)';
    envsallY=[ones(encount,1);-1*ones(frcount,1);-1*ones(gecount,1)];
    frvsallY=[-1*ones(encount,1);ones(frcount,1);-1*ones(gecount,1)];
    gevsallY=[-1*ones(encount,1);-1*ones(frcount,1);ones(gecount,1)];