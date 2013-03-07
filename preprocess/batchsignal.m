%convert wave into sigal in batch
%Input:
%   location  -- director for wav files
%Return:
%   signallist -- cell array of wav signals
%   fslist     -- array of sample rates
function [signallist, fslist] = batchsignal(location)


%obtain all files names in a given directory into .wav
structlist=dir(location);
filecount=size(structlist,1);
filelist=cell(1, filecount-2, 1);
for i=3:1:filecount
    filelist{i-2} = [location, '/', getfield(structlist(i), 'name')];
end

signallist=cell(1, filecount-2);
fslist=zeros(filecount-2, 1);

for i=1:1:filecount - 2
    [signallist{i}, fslist(i)] =  wav2signal(filelist{i});     
end