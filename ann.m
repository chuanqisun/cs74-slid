%example

%make sure you have batch1.mat
%if not, generate from the demo section in automateimport.m

addpath('ann');
addpath('preprocess');
load('batch1.mat');

nettrain(train_data,test_data,[45, 30, 3],1000,0.9,0.01,10,0.01,10);