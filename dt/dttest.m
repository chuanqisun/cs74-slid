%multiclass decision tree test
%examples
%Input:
%   testX -- example inputs
%   testY -- example outputs
%   tree -- decision tree matrix
%Return:
%   distrib_matrix: confusion matrix. element on [i,j] is the number of
%       examples with actual label i falling predicted as j, the last column is
%       a sum for the prediction for each language, the lower right corner is
%       the total number of examples
%   correct_matrix: similar to distgrib_matrix, the label count is replaced
%       by percentage
%   raw_output -- continous output for accumulative prediction
function [distrib_matrix, correct_matrix, raw_output] = dttest(testX,testY,tree)

distrib_matrix=zeros(4);
correct_matrix=zeros(4);    
m=size(testY,2);

[output, raw_output]  = run_decision_tree( testX, testY, tree );
testX=testX';
testY=testY';


%for each eample in testY
for i=1:m

    
    predict_idx=1;
    %get predict index
    for j=2:3
        if output(i,j)==1
            predict_idx=j;
        end
    end
    
    actual_idx=1;
    %compute actual index
    for j=2:3
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
        
