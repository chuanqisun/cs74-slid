%svm file test
function [distrib_matrix, correct_matrix]=svmfiletest(test_data,enSV,frSV,geSV,degree)

en_marker=test_data.en_marker;
fr_marker=test_data.fr_marker;
ge_marker=test_data.ge_marker;
enY=test_data.en_Y';
frY=test_data.fr_Y';
geY=test_data.ge_Y';
enX=test_data.en_X';
frX=test_data.fr_X';
geX=test_data.ge_X';
testX=cat(1,enX,frX,geX);
testY=cat(1,enY,frY,geY);
[distrib_matrix, correct_matrix, en_raw_output] = svmtest(enX,enY,enSV,frSV,geSV,degree);
[distrib_matrix, correct_matrix, fr_raw_output] = svmtest(frX,frY,enSV,frSV,geSV,degree);
[distrib_matrix, correct_matrix, ge_raw_output] = svmtest(geX,geY,enSV,frSV,geSV,degree);

[en_f,en_distrib_matrix] = svmsimplefiletest(enY, en_raw_output, en_marker);
[fr_f,fr_distrib_matrix] = svmsimplefiletest(frY, fr_raw_output, fr_marker);
[ge_f,ge_distrib_matrix] = svmsimplefiletest(geY, ge_raw_output, ge_marker);
distrib_matrix=en_distrib_matrix+fr_distrib_matrix+ge_distrib_matrix;


correct_matrix=zeros(4);
f=en_f+fr_f+ge_f;
for i=1:3
    for j=1:3
        correct_matrix(i,j)=distrib_matrix(i,j)/f;
    end
end

correct_matrix(4,4)=distrib_matrix(4,4)/f;
for j=1:3
    correct_matrix(j,4)=distrib_matrix(j,j)/distrib_matrix(j,4);
end
      