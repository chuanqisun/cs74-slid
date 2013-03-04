% single out support vectors for testing
function [SVstruct] = collectSV(alpha, trainX, trainY, threshold, kernel_matrix)

% register support vectors
SVx=[];
SValpha=[];
SVy=[];
SVidx=[];
SVcount=0;
for i=1:size(alpha,1)
    if alpha(i)>threshold
        SVx=[SVx;trainX(i,:)];
        SValpha=[SValpha;alpha(i)];
        SVy=[SVy;trainY(i)];
        SVidx=[SVidx;i];
        SVcount = SVcount+1;
    end
end

% compute bias b
b=0;
outtersum=0;
for i=1:size(SVx,1)
    innersum=0;
    for j=1:size(SVx,1)
        innersum=innersum + SValpha(j)*SVy(j)*kernel_matrix(SVidx(i),SVidx(j));
    end
    outtersum=outtersum+SVy(i) - innersum;
end
b=outtersum/size(SVx,1);


f1='SVx';
f2='SValpha';
f3='SVy';
f4='SVidx';
f5='SVcount';
f6='bias';
SVstruct=struct(f1,SVx,f2,SValpha,f3,SVy,f4,SVidx,f5,SVcount,f6,b);
