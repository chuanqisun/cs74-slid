slid
====
spoken language identification
 -----------------------
| 1. basic information  |
 -----------------------
author:             Jingwei Pan, Chuanqi Sun
date:               2013/3/8
discription:        This is a project for CS74, taught by Professor Torresani 
                    in winter 2013. The program solves the spoken language
                    identification problem with artificial neural network,
                    but also provides implementation of SVM and decision-
                    tree for comparison.
course website:     http://www.cs.dartmouth.edu/~lorenzo/teaching/cs174/
software version:   MATLAB R2012b

 -------------------------
| 2. directory structure  |
 -------------------------
./slid/ ------------------------------ scripts, readme file, and compoments
    /ann/ ---------------------------- artificial neural network components
    /dt/ ----------------------------- decision tree omponents
    /mfcc/ --------------------------- [EXTERNAL RESOURCES] mel freqency cepstral coefficients extraction 
    /preprocess/ --------------------- signal preprocess and file I/O utilities
    /svm/ ---------------------------- SVM components
    /vad/ ---------------------------- [EXTERNAL RESOURCES] voice activity detection
    /voicebox/ ----------------------- [EXTERNAL RESOURCES] utilities for mfcc

./wav/ ------------------------------- (not included in the submission) resources directory
    /en/
        /train/ ---------------------- load it with train examples
        /test/ ----------------------- load it with test examples
    /fr/
        /train/
        /test/
    /ge/
        /train/
        /test/

 ---------------------------
| 3. how to set up and run  |
 ---------------------------
(1) create the resources directory as shown above;
(2) fill each sub directory in ./wav with wave files from each language; 
(3) make sure no miscellaneous or hidden files exist in ./wav and its sub directories;
(4) run proper sections of automateimport.m to preprocess and store the preprocessed data;
(4) load the preprocessed data into current workspace;
(5) open automatenet.m, fill the ARG matrix with parameters matching those in your workspace;
(6) run automatenet.m and the training process with be displayed, the outcome will be stored
    in ./slid;
(7) run automatesvm.m and automatedt.m the same way as in (6);
    WARNING: you computer may crash from running automatesvm.m on large dataset. 
(8) load and analyze results.

for detailed information about functions and parameters, please see the comments in files.