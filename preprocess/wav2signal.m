function [signal, fs]=wav2signal(filename)

%convert .wav file to speech signal with silenced part removed
addpath('./vad');

%read .wav file into 1D array [signal, sampling_rate]=wavread('filename')
[segments,fs]=detectVoiced(filename);

%compute number of segments
n=size(segments, 2);

%put all segments together into signal
signal=[];
for i=1:n
    signal=[signal;cell2mat(segments(i))];    
end

