%Generate X vector directly from given directory
%A wrapper function to simplify code
%Input:
%   dir     -- directory from which the X vector should be generated
%   Tw      -- Window size
%   Ts      -- Time shift
%   C       -- number of MFCC
function [X,marker]=pipelineX(dir,Tw,Ts,C)

    %load all languages into signals
    [signallist, fslist] = batchsignal(dir);
    %convert into mfcc
    [mfcclist] = batchmfcc(signallist,fslist,Tw,Ts,C);
    %generate file delimiter
    [marker] = generatemarker(mfcclist);
    %generateX
    [X]=generateX(mfcclist);
    
end