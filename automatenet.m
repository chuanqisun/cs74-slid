% automated ANN test script
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


ARG=[
25, 15, 15
];

repeat = 3;  %number of times each parameter combination is tested

addpath('ann');

for i=1:size(ARG,1)
    

    Tw=ARG(i,1);
    Ts=ARG(i,2);
    MFCC=ARG(i,3);


    train_name=eval(strcat('train_data_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC)));
    test_name=eval(strcat('test_data_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC)));
    result_name=strcat('ann_result_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC));
    figure_name=strcat('ann_figure_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC), '.fig');


    topo=[45, 30, 3];       %topology
    max_epoch=1000;         %max number of epochs
    l_rate=0.5;             %learning rate
    lambda=0.01;            %regularization
    fail_threshold=3;       %number of continuous validation failures allowed
    convergence_mse=0.01;   %convergence mse
    k=10;                   %k-fold

    best_validation_error=Inf;

    for j=1:repeat
        [result,figure]=nettrain(train_name,test_name, topo,max_epoch,l_rate,lambda,fail_threshold,convergence_mse,k);
        if result.validation_error_rate < best_validation_error
            best_validation_error = result.validation_error_rate;
            best_result=result;
            best_figure=figure;
        end
    end

    save(result_name, 'best_result');
    saveas(best_figure, figure_name);
   
end

close all;
