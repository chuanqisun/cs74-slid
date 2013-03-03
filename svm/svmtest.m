load('iris_subset.mat');

hold all;
% first plot the data
gscatter(trainsetX(:,1), trainsetX(:,2), trainsetY, 'br', 'ox');

% compute alpha for C=100
[alpha, fval, exitflag, output, lambda, r, m]=q1h(100,3);


% register support vectors
SVx=[];
SValpha=[];
SVy=[];
SVidx=[];
threshold=1e-5;
for i=1:m
    if alpha(i)>threshold
        SVx=[SVx;trainsetX(i,:)];
        SValpha=[SValpha;alpha(i)];
        SVy=[SVy;trainsetY(i)];
        SVidx=[SVidx;i];
    end
end

% compute bias b
b=0;
kernel_matrix=kernel(trainsetX,3);
outtersum=0;
for i=1:size(SVx,1)
    innersum=0;
    for j=1:size(SVx,1)
        innersum=innersum + SValpha(j)*SVy(j)*kernel_matrix(SVidx(i),SVidx(j));
    end
    outtersum=outtersum+SVy(i) - innersum;
end
b=outtersum/size(SVx,1);


% report # SVs
disp('number of support vectors:');
disp(size(SVx,1));

%plot bundary with brutal force
minx1=[];
minx2=[];
idx=0;
for x1=4:0.01:7
    idx=idx+1;
    for x2=1:0.01:5.5
        y=0;
        for i=1:size(SVx,1)
            y=y+SValpha(i)*SVy(i)*((SVx(i,:)*[x1,x2]')^3);
        end
        y=y+b;
        if (abs(y)<0.01)
            minx1=[minx1,x1];
            minx2=[minx2,x2];
        end
    end
end
plot(minx1,minx2, 'k');