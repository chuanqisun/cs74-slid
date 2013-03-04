%svm demo
addpath('./svm');
addpath('./preprocess');
[train_data]=preprocess('train',250,150,15);
[test_data]=preprocess('test',250,150,15);
[trainX,envsallY,frvsallY,gevsallY,testX,testY,kernel_matrix]=svmpreprocess(train_data,test_data,1);
[enSV]=svmtrain(trainX,envsallY,kernel_matrix,100,1e-5);
[frSV]=svmtrain(trainX,frvsallY,kernel_matrix,100,1e-5); 
[geSV]=svmtrain(trainX,gevsallY,kernel_matrix,100,1e-5);
[frame_distrib_matrix, frame_correct_matrix, raw_output] = svmtest(testX,testY,enSV,frSV,geSV,1);
[file_distrib_matrix, file_correct_matrix]=svmfiletest(test_data,enSV,frSV,geSV,1);