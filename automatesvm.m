%% make sure you have already loaded the data
%
% automated SVM test script
%
% ARG= 
%[
%Tw1, Ts1, MFCC1
%Tw2, Ts2, MFCC2
%...  ...  ...
%]

addpath('./svm');


ARG=[
400, 160, 15;
400, 200, 15;
400, 240, 15;
400, 280, 15
];




for i=1:size(ARG,1)
    

    Tw=ARG(i,1);
    Ts=ARG(i,2);
    MFCC=ARG(i,3);


    train_name=eval(strcat('train_data_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC)));
    test_name=eval(strcat('test_data_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC)));
    result_name=strcat('svm_result_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC));


    [trainX,envsallY,frvsallY,gevsallY,testX,testY,kernel_matrix]=svmpreprocess(train_name,test_name,1);
    [enSV]=svmtrain(trainX,envsallY,kernel_matrix,100,1e-5);
    [frSV]=svmtrain(trainX,frvsallY,kernel_matrix,100,1e-5); 
    [geSV]=svmtrain(trainX,gevsallY,kernel_matrix,100,1e-5);
    [frame_distrib_matrix, frame_correct_matrix] = svmtest(testX,testY,enSV,frSV,geSV,1);
    [file_distrib_matrix, file_correct_matrix]=svmfiletest(test_data,enSV,frSV,geSV,1);

    
    f1='frame_distrib_matrix';
    v1=frame_distrib_matrix;
    f2='frame_correct_matrix';
    v2=frame_correct_matrix;
    f3='file_distrib_matrix';
    v3=file_distrib_matrix;
    f4='file_correct_matrix';
    v4=file_correct_matrix;
    best_result=struct(f1,v1,f2,v2,f3,v3,f4,v4);

    save(result_name, 'best_result');
   
end

close all;
