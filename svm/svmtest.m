%test svm multiclass classification error rate
function [distrib_matrix, correct_matrix, raw_output] = svmtest(testX,testY,enSV,frSV,geSV,degree)

distrib_matrix=zeros(4);
correct_matrix=zeros(4);    
m=size(testX,1);

%prepare raw_output matrix
raw_output=zeros(m,3);

%for each eample in testX
for i=1:m

    %compute prediction
    predict_idx=1;
    score_en=svmsimpletest(testX(i,:),enSV,degree);
    max_score=score_en;
    score_fr=svmsimpletest(testX(i,:),frSV,degree);
    if score_fr>max_score
        max_score=score_fr;
        predict_idx=2;
    end
    score_ge=svmsimpletest(testX(i,:),geSV,degree);
    if score_ge>max_score
        predict_idx=3;
    end
    
    %store raw output
    raw_output(i,:) = [score_en, score_fr, score_ge];
   
    %compute actual index
    for j=1:3
        if testY(i,j)==1
            actual_idx=j;
        end
    end
    
    %write error matrix
    distrib_matrix(actual_idx, predict_idx) = distrib_matrix(actual_idx, predict_idx) + 1;
    
end


distrib_matrix(:,4)=sum(distrib_matrix(:,1:3),2);
distrib_matrix(4,4)=distrib_matrix(1,1)+distrib_matrix(2,2)+distrib_matrix(3,3);


for i=1:3
    for j=1:3
        correct_matrix(i,j)=distrib_matrix(i,j)/m;
    end
end

correct_matrix(4,4)=distrib_matrix(4,4)/m;
for j=1:3
    correct_matrix(j,4)=distrib_matrix(j,j)/distrib_matrix(j,4);
end
        
