%generate X vector from flatmfcclist
%Input:
%   mfcclist -- cell array of mfccs for each file
%Return:
%   X -- X matrix compatible with training data format
function [X]=generateX(mfcclist)

    X=[];
    %loop through all files
    for i=1:size(mfcclist,2)
        X=cat(2,X,mfcclist{i});
    end

end