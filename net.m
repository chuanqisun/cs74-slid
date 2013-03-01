load('gmenfr.mat');
addpath('ann');
nettrain(trainX,trainY,[45,30,3],1000,0.9,0.1,10);