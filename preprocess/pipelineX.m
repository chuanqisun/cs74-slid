%flatgenerateXY
%for one language, combine output of flatX and flatY into single X, Y for ANN processing
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