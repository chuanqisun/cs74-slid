%Convert a single signal array into mfcc vectors
%Input:
%   signal  -- wav signal
%   fs      -- file sampling rate
%   Tw      -- analysis frame duration (ms)
%   Ts      -- analysis frame shift (ms)
%   C       -- number of cepstral coefficients
%Return:
%   mfccs   -- array of MFCC
function [mfccs] = signal2mfcc(signal,fs,Tw,Ts,C)

%add mfcc function and its denpendant toolbox
addpath('./mfcc','./voicebox');


%prepare for MFCC computation
        
alpha = 0.97;      % preemphasis coefficient
R = [ 300 3700 ];  % frequency range to consider
M = 20;            % number of filterbank channels             
L = 22;            % cepstral sine lifter parameter

% hamming window 
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));

mfccs = mfcc( signal, fs, Tw, Ts, alpha, hamming, R, M, C, L );
mfccs = mfccs(:,~isnan(mfccs(1,:))); %sanitize the mfcc

