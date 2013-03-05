%generate input data for ANN
%
% preparation
%   put language files in "../wav/en" "../wav/fr" "../wav/ge" directories
%   make sure none of these directories is empty
%
% input
%   Tw:     window size
%   Ts:     window shift
%   C:      number of cepstral coefficients
%
%   return:
%       mode:           ['train'|'test'] determine which directory to read
%       frame_count:    number of frames for each language
%       file_count:     number of files for each language
%       xx_X:           X vector for xx language
%       xx_Y:           Y vector for xx language
%       xx_marke        file delimiters for xx language


function [data]=preprocess(mode,Tw,Ts,C)

    
    f1='frame_count';
    f2='file_count';
    f3='en_X';
    f4='fr_X';
    f5='ge_X';
    f6='en_Y';
    f7='fr_Y';
    f8='ge_Y';
    f9='en_marker';
    f10='fr_marker';
    f11='ge_marker';

    en_dir=strcat('../wav/en/',mode);
    fr_dir=strcat('../wav/fr/',mode);
    ge_dir=strcat('../wav/ge/',mode);

    [en_X, en_marker]=pipelineX(en_dir,Tw,Ts,C);
    [fr_X, fr_marker]=pipelineX(fr_dir,Tw,Ts,C);
    [ge_X, ge_marker]=pipelineX(ge_dir,Tw,Ts,C);
    
    [en_Y]=generateY(en_X,[1;0;0]);
    [fr_Y]=generateY(fr_X,[0;1;0]);
    [ge_Y]=generateY(ge_X,[0;0;1]);    
    
    
    frame_count=[size(en_Y,2),size(fr_Y,2),size(ge_Y,2)];
    file_count=[size(en_marker,2),size(fr_marker,2),size(ge_marker,2)];
    
    data=struct(f1,frame_count,f2,file_count,f3,en_X,f4,fr_X,f5,ge_X,f6,en_Y,f7,fr_Y,f8,ge_Y,f9,en_marker,f10,fr_marker,f11,ge_marker);

end
    
    