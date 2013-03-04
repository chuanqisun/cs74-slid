%compute distance from boundary
function [score]=svmsimpletest(x,SVstruct,degree)
    SVx=SVstruct.SVx;
    SValpha=SVstruct.SValpha;
    SVy=SVstruct.SVy;
    score=SVstruct.bias;
    for i=1:size(SVx,1)
        score=score+SValpha(i)*SVy(i)*((SVx(i,:)*x')^degree);
    end