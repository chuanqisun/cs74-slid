%------demo------------------------
%note that batch1.mat is for demo
[train_data]=preprocess('train',25,15,15);
[test_data]=preprocess('test',25,15,15);
save('batch1.mat');
clear all;



%-------------TRAINING------------
[train_data_10_10_15]=preprocess('train',10,10,15);
[train_data_10_9_15]=preprocess('train',10,9,15);
[train_data_10_8_15]=preprocess('train',10,8,15);
[train_data_10_7_15]=preprocess('train',10,7,15);
[train_data_10_6_15]=preprocess('train',10,6,15);
[train_data_10_5_15]=preprocess('train',10,5,15);
[train_data_10_4_15]=preprocess('train',10,4,15);

save('batch2.mat');
clear all;
[train_data_10_3_15]=preprocess('train',10,3,15);
[train_data_15_15_15]=preprocess('train',15,15,15);
[train_data_15_14_15]=preprocess('train',15,14,15);
[train_data_15_12_15]=preprocess('train',15,12,15);
[train_data_15_11_15]=preprocess('train',15,11,15);
[train_data_15_9_15]=preprocess('train',15,9,15);
[train_data_15_8_15]=preprocess('train',15,8,15);

save('batch3.mat');
clear all;
[train_data_15_6_15]=preprocess('train',15,6,15);
[train_data_15_5_15]=preprocess('train',15,5,15);
[train_data_20_20_15]=preprocess('train',20,20,15);
[train_data_20_18_15]=preprocess('train',20,18,15);
[train_data_20_16_15]=preprocess('train',20,16,15);
[train_data_20_14_15]=preprocess('train',20,14,15);
[train_data_20_12_15]=preprocess('train',20,12,15);
save('batch4.mat');
clear all;

[train_data_20_10_15]=preprocess('train',20,10,15);
[train_data_20_8_15]=preprocess('train',20,8,15);
[train_data_20_6_15]=preprocess('train',20,6,15);
[train_data_25_25_15]=preprocess('train',25,25,15);
[train_data_25_23_15]=preprocess('train',25,23,15);
[train_data_25_20_15]=preprocess('train',25,20,15);
[train_data_25_18_15]=preprocess('train',25,18,15);
[train_data_25_15_15]=preprocess('train',25,15,15);
[train_data_25_13_15]=preprocess('train',25,13,15);
save('batch5.mat');
clear all;

[train_data_25_10_15]=preprocess('train',25,10,15);
[train_data_25_8_15]=preprocess('train',25,8,15);
[train_data_50_50_15]=preprocess('train',50,50,15);
[train_data_50_45_15]=preprocess('train',50,45,15);
[train_data_50_40_15]=preprocess('train',50,40,15);
[train_data_50_35_15]=preprocess('train',50,35,15);
[train_data_50_30_15]=preprocess('train',50,30,15);
[train_data_50_25_15]=preprocess('train',50,25,15);
save('batch6.mat');
clear all;

[train_data_50_20_15]=preprocess('train',50,20,15);
[train_data_50_15_15]=preprocess('train',50,15,15);
[train_data_100_100_15]=preprocess('train',100,100,15);
[train_data_100_90_15]=preprocess('train',100,90,15);
[train_data_100_80_15]=preprocess('train',100,80,15);
[train_data_100_70_15]=preprocess('train',100,70,15);
[train_data_100_60_15]=preprocess('train',100,60,15);
[train_data_100_50_15]=preprocess('train',100,50,15);
[train_data_100_40_15]=preprocess('train',100,40,15);
save('batch7.mat');
clear all;

[train_data_100_30_15]=preprocess('train',100,30,15);
[train_data_200_200_15]=preprocess('train',200,200,15);
[train_data_200_180_15]=preprocess('train',200,180,15);
[train_data_200_160_15]=preprocess('train',200,160,15);
[train_data_200_140_15]=preprocess('train',200,140,15);
[train_data_200_120_15]=preprocess('train',200,120,15);
[train_data_200_100_15]=preprocess('train',200,100,15);
[train_data_200_80_15]=preprocess('train',200,80,15);
save('batch8.mat');
clear all;

[train_data_200_60_15]=preprocess('train',200,60,15);
[train_data_300_300_15]=preprocess('train',300,300,15);
[train_data_300_270_15]=preprocess('train',300,270,15);
[train_data_300_240_15]=preprocess('train',300,240,15);
[train_data_300_210_15]=preprocess('train',300,210,15);
save('batch9.mat');
clear all;

[train_data_300_180_15]=preprocess('train',300,180,15);
[train_data_300_150_15]=preprocess('train',300,150,15);
[train_data_300_120_15]=preprocess('train',300,120,15);
[train_data_300_90_15]=preprocess('train',300,90,15);
[train_data_400_400_15]=preprocess('train',400,400,15);
[train_data_400_360_15]=preprocess('train',400,360,15);
[train_data_400_320_15]=preprocess('train',400,320,15);
save('batch10.mat');
clear all;

[train_data_400_280_15]=preprocess('train',400,280,15);
[train_data_400_240_15]=preprocess('train',400,240,15);
[train_data_400_200_15]=preprocess('train',400,200,15);
[train_data_400_160_15]=preprocess('train',400,160,15);
save('batch11.mat');
clear all;

[train_data_400_120_15]=preprocess('train',400,120,15);
[train_data_500_500_15]=preprocess('train',500,500,15);
[train_data_500_450_15]=preprocess('train',500,450,15);
[train_data_500_400_15]=preprocess('train',500,400,15);
[train_data_500_350_15]=preprocess('train',500,350,15);
save('batch12.mat');
clear all;

[train_data_500_300_15]=preprocess('train',500,300,15);
[train_data_500_250_15]=preprocess('train',500,250,15);
[train_data_500_200_15]=preprocess('train',500,200,15);
[train_data_500_150_15]=preprocess('train',500,150,15);
save('batch13.mat');
clear all;


%-------TEST---------------
[test_data_10_10_15]=preprocess('test',10,10,15);
[test_data_10_9_15]=preprocess('test',10,9,15);
[test_data_10_8_15]=preprocess('test',10,8,15);
[test_data_10_7_15]=preprocess('test',10,7,15);
[test_data_10_6_15]=preprocess('test',10,6,15);
[test_data_10_5_15]=preprocess('test',10,5,15);
[test_data_10_4_15]=preprocess('test',10,4,15);
[test_data_10_3_15]=preprocess('test',10,3,15);
[test_data_15_15_15]=preprocess('test',15,15,15);
[test_data_15_14_15]=preprocess('test',15,14,15);
[test_data_15_12_15]=preprocess('test',15,12,15);
save('batch14.mat');
clear all;

[test_data_15_11_15]=preprocess('test',15,11,15);
[test_data_15_9_15]=preprocess('test',15,9,15);
[test_data_15_8_15]=preprocess('test',15,8,15);
[test_data_15_6_15]=preprocess('test',15,6,15);
[test_data_15_5_15]=preprocess('test',15,5,15);
[test_data_20_20_15]=preprocess('test',20,20,15);
save('batch15.mat');
clear all;

[test_data_20_18_15]=preprocess('test',20,18,15);
[test_data_20_16_15]=preprocess('test',20,16,15);
[test_data_20_14_15]=preprocess('test',20,14,15);
[test_data_20_12_15]=preprocess('test',20,12,15);
[test_data_20_10_15]=preprocess('test',20,10,15);
[test_data_20_8_15]=preprocess('test',20,8,15);
[test_data_20_6_15]=preprocess('test',20,6,15);
[test_data_25_25_15]=preprocess('test',25,25,15);
save('batch16.mat');
clear all;

[test_data_25_23_15]=preprocess('test',25,23,15);
[test_data_25_20_15]=preprocess('test',25,20,15);
[test_data_25_18_15]=preprocess('test',25,18,15);
[test_data_25_15_15]=preprocess('test',25,15,15);
[test_data_25_13_15]=preprocess('test',25,13,15);
[test_data_25_10_15]=preprocess('test',25,10,15);
save('batch17.mat');
clear all;

[test_data_25_8_15]=preprocess('test',25,8,15);
[test_data_50_50_15]=preprocess('test',50,50,15);
[test_data_50_45_15]=preprocess('test',50,45,15);
[test_data_50_40_15]=preprocess('test',50,40,15);
[test_data_50_35_15]=preprocess('test',50,35,15);
[test_data_50_30_15]=preprocess('test',50,30,15);
save('batch18.mat');
clear all;

[test_data_50_25_15]=preprocess('test',50,25,15);
[test_data_50_20_15]=preprocess('test',50,20,15);
[test_data_50_15_15]=preprocess('test',50,15,15);
[test_data_100_100_15]=preprocess('test',100,100,15);
[test_data_100_90_15]=preprocess('test',100,90,15);
[test_data_100_80_15]=preprocess('test',100,80,15);
[test_data_100_70_15]=preprocess('test',100,70,15);
save('batch19.mat');
clear all;

[test_data_100_60_15]=preprocess('test',100,60,15);
[test_data_100_50_15]=preprocess('test',100,50,15);
[test_data_100_40_15]=preprocess('test',100,40,15);
[test_data_100_30_15]=preprocess('test',100,30,15);
[test_data_200_200_15]=preprocess('test',200,200,15);
[test_data_200_180_15]=preprocess('test',200,180,15);
[test_data_200_160_15]=preprocess('test',200,160,15);
save('batch20.mat');
clear all;

[test_data_200_140_15]=preprocess('test',200,140,15);
[test_data_200_120_15]=preprocess('test',200,120,15);
[test_data_200_100_15]=preprocess('test',200,100,15);
[test_data_200_80_15]=preprocess('test',200,80,15);
[test_data_200_60_15]=preprocess('test',200,60,15);
[test_data_300_300_15]=preprocess('test',300,300,15);
save('batch21.mat');
clear all;

[test_data_300_270_15]=preprocess('test',300,270,15);
[test_data_300_240_15]=preprocess('test',300,240,15);
[test_data_300_210_15]=preprocess('test',300,210,15);
[test_data_300_180_15]=preprocess('test',300,180,15);
[test_data_300_150_15]=preprocess('test',300,150,15);
[test_data_300_120_15]=preprocess('test',300,120,15);
[test_data_300_90_15]=preprocess('test',300,90,15);
save('batch22.mat');
clear all;

[test_data_400_400_15]=preprocess('test',400,400,15);
[test_data_400_360_15]=preprocess('test',400,360,15);
[test_data_400_320_15]=preprocess('test',400,320,15);
[test_data_400_280_15]=preprocess('test',400,280,15);
[test_data_400_240_15]=preprocess('test',400,240,15);
[test_data_400_200_15]=preprocess('test',400,200,15);
[test_data_400_160_15]=preprocess('test',400,160,15);
save('batch23.mat');
clear all;

[test_data_400_120_15]=preprocess('test',400,120,15);
[test_data_500_500_15]=preprocess('test',500,500,15);
[test_data_500_450_15]=preprocess('test',500,450,15);
[test_data_500_400_15]=preprocess('test',500,400,15);
[test_data_500_350_15]=preprocess('test',500,350,15);
save('batch24.mat');
clear all;

[test_data_500_300_15]=preprocess('test',500,300,15);
[test_data_500_250_15]=preprocess('test',500,250,15);
[test_data_500_200_15]=preprocess('test',500,200,15);
[test_data_500_150_15]=preprocess('test',500,150,15);
save('batch25.mat');
clear all;
