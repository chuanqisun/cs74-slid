% automated SVM test script
%
% load the data by running preprocess.m first
% fill the ARG matrix with arguments and run the script
%
% ARG= 
%[
%Tw1, Ts1, MFCC1
%Tw2, Ts2, MFCC2
%...  ...  ...
%]

addpath('./svm');


ARG=[
250,150,15
];




for i=1:size(ARG,1)
    

    Tw=ARG(i,1);
    Ts=ARG(i,2);
    MFCC=ARG(i,3);


    train_name=eval(strcat('train_data_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC)));
    test_name=eval(strcat('test_data_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC)));
    result_name=strcat('svm_result_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC));


    [trainX,envsallY,frvsallY,gevsallY,testX,testY,kernel_matrix]=svmpreprocess(train_name,test_name,1);
    [enSV]=svmtrain(trainX,envsallY,kernel_matrix,25,1e-5);
    [frSV]=svmtrain(trainX,frvsallY,kernel_matrix,25,1e-5); 
    [geSV]=svmtrain(trainX,gevsallY,kernel_matrix,25,1e-5);
    [frame_distrib_matrix, frame_correct_matrix] = svmtest(testX,testY,enSV,frSV,geSV,1);
    [file_distrib_matrix, file_correct_matrix]=svmfiletest(test_name,enSV,frSV,geSV,1);

    f1='enSV';
    v1=enSV;
    f2='frSV';
    v2=frSV;
    f3='geSV';
    v3=geSV;
    f4='frame_distrib_matrix';
    v4=frame_distrib_matrix;
    f5='frame_correct_matrix';
    v5=frame_correct_matrix;
    f6='file_distrib_matrix';
    v6=file_distrib_matrix;
    f7='file_correct_matrix';
    v7=file_correct_matrix;
    best_result=struct(f1,v1,f2,v2,f3,v3,f4,v4,f5,v5,f6,v6,f7,v7);

    save(result_name, 'best_result');
   
end

close all;
