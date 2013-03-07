%% make sure you have already loaded the data
%
% automated neural networks test script
%
% ARG= 
%[
%Tw1, Ts1, MFCC1
%Tw2, Ts2, MFCC2
%...  ...  ...
%]


ARG=[
200, 180, 15
];

repeat = 3;

addpath('ann');

for i=1:size(ARG,1)
    

    Tw=ARG(i,1);
    Ts=ARG(i,2);
    MFCC=ARG(i,3);


    train_name=eval(strcat('train_data_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC)));
    test_name=eval(strcat('test_data_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC)));
    result_name=strcat('ann_result_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC));
    figure_name=strcat('ann_figure_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC), '.fig');


    topo=[45, 30, 3];
    max_epoch=1000;
    l_rate=0.5;
    lambda=0.01;
    fail_threshold=3;
    convergence_mse=0.01;
    k=10;

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
