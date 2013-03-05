function [ impurity ] = get_impurity( Y )
%Calculate impurity
%size(Y)
p1 = sum(Y(:, 1))/size(Y, 1); %fraction of English files
p2 = sum(Y(:, 2))/size(Y, 1); %fraction of French files
p3 = 1-p1-p2; %fraction of German files

p1_im = p1 * log(p1);
p2_im = p2 * log(p2);
p3_im = p3 * log(p3);

if p1 == 0
    p1_im = 0;
end

if p2 == 0
    p2_im = 0;
end

if p3 == 0
    p3_im = 0;
end
impurity = -(p1_im + p2_im + p3_im);

%if(p1 == 0 || p0 == 0)
%    impurity = 0;
%end
end

