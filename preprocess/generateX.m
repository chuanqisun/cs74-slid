%generate X vector from flatmfcclist given number of neurons in input layer
% limit applies to number of mfcc vectors for each file
function [X]=generateX(mfcclist)

    X=[];
    %loop through all files
    for i=1:size(mfcclist,2)
        X=cat(2,X,mfcclist{i});
    end

end