%compute error rate and confusion matrices given the predicted and actual
%Y labels
%
%Input:
%   output: predicted labels
%   testY:  actual labels
%Return:
%   error_rate: error rate for all languages
%   distrib_matrix: confusion matrix. element on [i,j] is the number of
%       examples with actual label i falling predicted as j, the last column is
%       a sum for the prediction for each language, the lower right corner is
%       the total number of examples
%   correct_matrix: similar to distgrib_matrix, the label count is replaced
%       by percentage
function [ error_rate, distrib_matrix, correct_matrix ] = calculate_error_rate(output, testY)

    %init confusion matrices
    distrib_matrix=zeros(4);
    correct_matrix=zeros(4);   

    m=size(testY,1);
    
    for i = 1:m
        %compute actual index
        act_idx=1;
        pre_idx=1;
        for j=2:3
            if testY(i,j)==1
                act_idx=j;
            end
            if output(i,j)==1
                pre_idx=j;
            end
        end
    
        %write error matrix
        distrib_matrix(act_idx, pre_idx) = distrib_matrix(act_idx, pre_idx) + 1;
    end
    
    
    
    distrib_matrix(:,4)=sum(distrib_matrix(:,1:3),2);
    distrib_matrix(4,4)=distrib_matrix(1,1)+distrib_matrix(2,2)+distrib_matrix(3,3);

    %compute percentage performance from distribution matrix
    for i=1:3
        for j=1:3
            correct_matrix(i,j)=distrib_matrix(i,j)/m;
        end
    end

    correct_matrix(4,4)=distrib_matrix(4,4)/m;
    for j=1:3
        correct_matrix(j,4)=distrib_matrix(j,j)/distrib_matrix(j,4);
    end
    
    
    
    error_rate= 1 - correct_matrix(4,4);
end

