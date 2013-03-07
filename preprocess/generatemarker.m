%genderate file limiter from mfcclist
%Input:
%   mfcclist -- cell array of mfccs for each file
%Return:
%   marker -- delimiter marking the beginning and ending mfcc for each file
function [marker] = generatemarker(mfcclist)

    mfcccount = size(mfcclist,2);
    marker = zeros(2, mfcccount + 1);
    marker(1,1)=1;
    for i = 1:mfcccount
        marker(1,i+1)=marker(1,i) + size(mfcclist{i},2);
        marker(2,i)=marker(1,i+1)-1;
    end
    marker=marker(:,1:mfcccount);
end