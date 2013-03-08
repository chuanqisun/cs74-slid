%ploynomial kernel function, when degree=1, it is a linear kernel
%Input:
%   x -- X on which kernel is computed
%   degree -- the degree of ploynomial kernel
function [kernel_matrix]=kernel(x,degree)
    xsize=size(x,1);
    kernel_matrix=zeros(xsize);
    for i=1:xsize
        for j=1:xsize
            kernel_matrix(i,j)=(x(i,:)*x(j,:)')^degree;
        end
    end
end