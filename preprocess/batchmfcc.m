function [mfcclist] = batchmfcc(signallist, fslist,Tw,Ts,C)

%convert every signal in a cell array into MFCC vectors

file_count=size(signallist, 2);
mfcclist=cell(1,file_count);
for i=1:1:file_count
    mfcclist{i} = signal2mfcc(signallist{i}, fslist(i),Tw,Ts,C);
    mfcclength = size(mfcclist{i},2);
    deltamfcc=zeros(size(mfcclist{i},1),mfcclength-1);
    deltadeltamfcc=zeros(size(mfcclist{i},1),mfcclength-2);
    for j=1:1:(mfcclength-1)
        deltamfcc(:,j)=mfcclist{i}(:,j+1) - mfcclist{i}(:,j);
    end
    for j=1:1:(mfcclength-2)
        deltadeltamfcc(:,j)=deltamfcc(:,j+1) - deltamfcc(:,j);
    end
    mfcclist{i} = cat(1,mfcclist{i}(:,1:mfcclength-2), deltamfcc(:,1:mfcclength-2),deltadeltamfcc);
    
end