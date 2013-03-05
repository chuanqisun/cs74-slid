%% make sure you have already loaded the data
% ARG= 
%[
%Tw1, Ts1, MFCC1
%Tw2, Ts2, MFCC2
%...  ...  ...
%]


ARG=[
400, 280, 15
];

repeat = 3;

addpath('dt');

for i=1:size(ARG,1)
    

    Tw=ARG(i,1);
    Ts=ARG(i,2);
    MFCC=ARG(i,3);


    train_name=eval(strcat('train_data_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC)));
    test_name=eval(strcat('test_data_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC)));
    result_name=strcat('dt_result_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC));

    [trainX,trainY,testX,testY] = dtpreprocess(train_name, test_name);
    [tree] = DecisionTree2(trainX, trainY, 0.01);
    [frame_distrib_matrix, frame_correct_matrix] = dttest(testX,testY,tree);
    [file_distrib_matrix, file_correct_matrix] = dtfiletest(test_name,tree);

    
        
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