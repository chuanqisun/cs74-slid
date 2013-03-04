%test svm multiclass classification error rate
function [f,distrib_matrix] = svmsimplefiletest(testY, raw_output, marker)

distrib_matrix=zeros(4);   
f=size(marker,2);
raw_file_output=zeros(f,3);
%for each eample in testX
for i=1:f
    %get per file location
    head=marker(1,i);
    tail=marker(2,i);
    %compute prediction
    raw_file_output(i,:)=sum(raw_output(head:tail,:),1);
    
    %get prediction idx
    pre_idx=1;
    for j=2:3
        if raw_file_output(i,j)>raw_file_output(i,pre_idx)
            pre_idx=j;
        end
    end
    
    %get actual idx
    act_idx=1;
    for j=2:3
        if testY(head,j)==1
            act_idx=j;
        end
    end
    
    %write error matrix
    distrib_matrix(act_idx, pre_idx) = distrib_matrix(act_idx, pre_idx) + 1;
    
end


distrib_matrix(:,4)=sum(distrib_matrix(:,1:3),2);
distrib_matrix(4,4)=distrib_matrix(1,1)+distrib_matrix(2,2)+distrib_matrix(3,3);
  
