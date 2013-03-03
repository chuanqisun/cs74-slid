%% dual formulation
%degree = ploynomial kernel degree
function [alpha, fval, exitflag, output, lambda, r, m]=svmtrain(trainX,trainY,C,degree)

%compute number of samples
m=size(trainX,1);
%compute number of features
r=size(trainX,2);

%compute kernel matrix
kernel_matrix=kernel(trainX,degree);

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

% call MATLAB quadprog
opts = optimset('Algorithm','interior-point-convex');
[alpha, fval, exitflag, output, lambda]= quadprog(H, f, A, d, Aeq, deq, lb, ub, [], opts);
end