function [ output, raw ] = DecisiontreeAutomate( train_name, test_name)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

en_trainX = train_name.en_X;
fr_trainX = train_name.fr_X;
ge_trainX = train_name.ge_X;

en_trainY = train_name.en_Y;
fr_trainY = train_name.fr_Y;
ge_trainY = train_name.ge_Y;

trainX = cat(2, en_trainX, fr_trainX, ge_trainX);
trainY = cat(2, en_trainY, fr_trainY, ge_trainY);

en_testX = test_name.en_X;
fr_testX = test_name.fr_X;
ge_testX = test_name.ge_X;

en_testY = test_name.en_Y;
fr_testY = test_name.fr_Y;
ge_testY = test_name.ge_Y;

testX = cat(2, en_testX, fr_testX, ge_testX);
testY = cat(2, en_testY, fr_testY, ge_testY);

tree = DecisionTree2(trainX, trainY, 0.01);
[output, raw] = run_decision_tree(testX, testY, tree);

end

