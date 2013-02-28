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
%       count:          number of valid input files for each language
%       en_fr_ge_X:     X vector for 3 languages
%       en_fr_ge_Y:     Y vector for 3 languages
%       xx_xx_X:        X vector for 2 languages
%       xx_xx_Y:        Y vector for 2 languages
%       xx_X:           X vector for 1 language
%       xx_Y:           Y vector for 1 language


function [count, en_fr_ge_X,en_fr_ge_Y,en_fr_X,en_fr_Y,en_ge_X,en_ge_Y,fr_ge_X,fr_ge_Y,en_X,fr_X,ge_X,en_Y,fr_Y,ge_Y]=preprocess(Tw,Ts,C)
    
    addpath('./preprocess');
    [en_X]=pipelineX('../wav/en',Tw,Ts,C);
    [fr_X]=pipelineX('../wav/fr',Tw,Ts,C);
    [ge_X]=pipelineX('../wav/ge',Tw,Ts,C);
    
    [en_Y]=generateY(en_X,[1;0;0]);
    [fr_Y]=generateY(fr_X,[0;1;0]);
    [ge_Y]=generateY(ge_X,[0;0;1]);
    
    en_fr_ge_X = cat(2, en_X, fr_X, ge_X);
    en_fr_ge_Y = cat(2, en_Y, fr_Y, ge_Y);
    
    [en_Y]=generateY(en_X,[1;0;0]);
    [fr_Y]=generateY(fr_X,[0;1;0]);
    
    en_fr_X = cat(2, en_X, fr_X);
    en_fr_Y = cat(2, en_Y, fr_Y);
   
    [en_Y]=generateY(en_X,[1;0;0]);
    [ge_Y]=generateY(ge_X,[0;0;1]);
    
    en_ge_X = cat(2, en_X, ge_X);
    en_ge_Y = cat(2, en_Y, ge_Y);
    
    [fr_Y]=generateY(fr_X,[0;1;0]);
    [ge_Y]=generateY(ge_X,[0;0;1]);
    
    fr_ge_X = cat(2, fr_X, ge_X);
    fr_ge_Y = cat(2, fr_Y, ge_Y);
    
    count=[size(en_Y,2),size(fr_Y,2),size(ge_Y,2)];

end
    
    