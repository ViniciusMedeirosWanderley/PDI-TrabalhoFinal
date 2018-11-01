function [I_r,Q_r] = GetQuadImage(I,Q,Pad)

Q_r = Quad2Rect(Q);

[R C b] = size(I);

min_r = Q.UL(1)-Pad;
max_r = Q.LL(1)+Pad;
min_c = Q.UL(2)-Pad;
max_c = Q.UR(2)+Pad;

if(min_r < 1)
    min_r = 1;
end

if(max_r > R)
    max_r = R;
end

if(min_c < 1)
    min_c = 1;
end

if(max_c > C)
    max_c = C;
end

I_r = I(min_r:max_r,min_c:max_c,:);
Q_r.UL = [min_r min_c];
Q_r.UR = [min_r max_c];
Q_r.LL = [max_r min_c];
Q_r.LR = [max_r max_c];


end