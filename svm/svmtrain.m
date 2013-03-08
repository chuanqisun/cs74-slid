%train SVM with quadprog + dual formulation
%Input:
%   trainX       -- X from training set
%   trainY       -- Y from training set
%   kernel_matrix -- precomputed kernel_matrix
%   C            -- regularization
%   threshold    -- alpha might be very small positive number due to numerical issue, need a
%       threshold to find them

function [SVstruct]=svmtrain(trainX,trainY,kernel_matrix,C,threshold)

    %compute number of samples
    m=size(trainX,1);

    % prepare for H
    H=zeros(m);
    for i=1:m
        for j=1:m
            H(i,j)=trainY(i)*trainY(j)*kernel_matrix(i,j);
        end
    end

    % prepare for f
    f=-ones(m,1);

    % prepare for A, d
    A=[];
    d=[];

    % prepare for Aeq, deq
    Aeq=trainY';
    deq=0;

    % prepare for lb, ub
    lb=zeros(m,1);
    ub=C*ones(m,1);

    % call MATLAB quadprog (max iter = 100)
    opts = optimset('Algorithm','interior-point-convex','Display','iter','MaxIter', 100);
    [alpha]= quadprog(H, f, A, d, Aeq, deq, lb, ub, [], opts);
    SVstruct = collectSV(alpha, trainX, trainY, threshold,kernel_matrix);
end