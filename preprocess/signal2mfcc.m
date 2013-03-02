function [mfccs] = signal2mfcc(signal,fs,Tw,Ts,C)
%sample script demonstrating .wav input and MFCC computation
%
%Author: Chuanqi Sun
%Date:   1-30-13

%add mfcc function and its denpendant toolbox
addpath('./mfcc','./voicebox');


%prepare for MFCC computation

           %Tw = 25;           % analysis frame duration (ms)
           %Ts = 15;           % analysis frame shift (ms)
           alpha = 0.97;      % preemphasis coefficient
           R = [ 300 3700 ];  % frequency range to consider
           M = 20;            % number of filterbank channels 
           %C = 15;            % number of cepstral coefficients
           L = 22;            % cepstral sine lifter parameter
       
           % hamming window (see Eq. (5.2) on p.73 of [1])
           hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
           
mfccs = mfcc( signal, fs, Tw, Ts, alpha, hamming, R, M, C, L );
mfccs = mfccs(:,~isnan(mfccs(1,:)));

