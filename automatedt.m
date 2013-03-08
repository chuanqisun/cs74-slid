% automated Decision Tree test script
%
% load the data by running preprocess.m first
% fill the ARG matrix with arguments and run the script
%
% ARG= 
%[
%Tw1, Ts1, MFCC1
%Tw2, Ts2, MFCC2
%...  ...  ...
%


ARG=[
25, 15, 15
];

repeat = 3; %number of times each parameter combination is tested

addpath('dt');

for i=1:size(ARG,1)
    

    Tw=ARG(i,1);
    Ts=ARG(i,2);
    MFCC=ARG(i,3);
    C=0.5;

    train_name=eval(strcat('train_data_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC)));
    test_name=eval(strcat('test_data_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC)));
    result_name=strcat('dt_result_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC));

    [trainX,trainY,testX,testY] = dtpreprocess(train_name, test_name);
    [tree] = DecisionTree2(trainX, trainY, C);
    [frame_distrib_matrix, frame_correct_matrix] = dttest(testX,testY,tree);
    [file_distrib_matrix, file_correct_matrix] = dtfiletest(test_name,tree);

    
    f1='tree';
    v1=tree;
    f2='frame_distrib_matrix';
    v2=frame_distrib_matrix;
    f3='frame_correct_matrix';
    v3=frame_correct_matrix;
    f4='file_distrib_matrix';
    v4=file_distrib_matrix;
    f5='file_correct_matrix';
    v5=file_correct_matrix;
    best_result=struct(f1,v1,f2,v2,f3,v3,f4,v4,f5,v5);


    save(result_name, 'best_result');
   
end

close all;
