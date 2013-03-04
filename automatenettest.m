%% make sure you have already loaded the data
% ARG= 
%[
%Tw1, Ts1, MFCC1
%Tw2, Ts2, MFCC2
%...  ...  ...
%]


ARG=[
400, 320, 15;
400, 360, 15;
400, 400, 15
];

for i=1:size(ARG,1)
    

    Tw=ARG(i,1);
    Ts=ARG(i,2);
    MFCC=ARG(i,3);


    train_name=eval(strcat('train_data_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC)));
    test_name=eval(strcat('test_data_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC)));
    result_name=strcat('ann_result_', num2str(Tw), '_', num2str(Ts), '_' , num2str(MFCC));


    topo=[45, 30, 3];
    max_epoch=1000;
    l_rate=0.9;
    lambda=0.01;
    fail_threshold=3;
    convergence_mse=0.01;
    k=2;

    [result]=nettrain(train_name,test_name, topo,max_epoch,l_rate,lambda,fail_threshold,convergence_mse,k);

    save(result_name, 'result');
   
end

close all;