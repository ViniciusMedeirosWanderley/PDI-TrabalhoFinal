function [I,I_ef,M] = LinesCrop(I,I_ef)

I_orig = I;

[R C] = size(I_ef);

I_cnt_v = zeros(R,C);
I_cnt_h = zeros(R,C);

%Rank vertical lines
for c = 1:C
    for r = 2:R
        I_cnt_v(r,c) = I_ef(r,c).*(I_cnt_v(r-1,c)+1);
    end
end

R_rv = fliplr(1:R);
val = 1;

%Copy max vertical rank
for c = 1:C
    for r = 1:length(R_rv)
        if(I_cnt_v(R_rv(r),c) >= 1)
            if(val == 1)
                val = I_cnt_v(R_rv(r),c);
            else
                I_cnt_v(R_rv(r),c) = val;
            end
        else
            val = 1;
        end
    end
end

%Used for mask
V = max(I_cnt_v);
V(V < 2*median(V)) = 0;
V_ = V;
V(V > 0) = 1;
V = repmat(V,[R 1]);
V_ = repmat(V_,[R 1]);

%Rank horizontal lines
for r = 1:R
    for c = 2:C
        I_cnt_h(r,c) = I_ef(r,c).*(I_cnt_h(r,c-1)+1);
    end
end

C_rv = fliplr(1:C);
val = 1;

%Copy max horizontal rank
for r = 1:R
    for c = 1:length(C_rv)
        if(I_cnt_h(r,C_rv(c)) >= 1)
            if(val == 1)
                val = I_cnt_h(r,C_rv(c));
            else
                I_cnt_h(r,C_rv(c)) = val;
            end
        else
            val = 1;
        end
    end
end

%Used for mask
H = max(I_cnt_h');
H(H < 2*median(H)) =0;
%H(H < 0.9*max(H)) =0;
%H_s = sort(H);
%H(H < H_s(length(H_s)-70)) = 0;
H_ = H;
H(H > 0) = 1;
H = H';
H_ = H_';
H = repmat(H,[1 C]);
H_ = repmat(H_,[1 C]);

%I = I_cnt_h+I_cnt_v;
M = H+V;
%I = H_+V_;
M(M > 0) = 1;

%Find corners
%
%
I = I_cnt_h.*I_cnt_v;
%
%


%Rank Corners
%I = imregionalmax(I,18).*I;

%Take the top 250 corners or those in the top 90%
I_s = sort(I(:));
I_hist = hist(I(:),100);
cnt = sum(I_hist(10:100));
if(cnt > 500)
    cnt = 500;
end
I(I < I_s(length(I_s)-cnt))=0;%sum(I_hist(5:15)))) = 0;

%Convert to binary
I(I > 0) = 1;

%Dilate to combine close points
I = imdilate(I,ones(10,10));

%Merge regions into their means
LBL = bwlabel(I);
u = unique(LBL(:));
CP = zeros(size(LBL));
for i = 1:length(u)
   [r,c] = find(LBL == u(i));
   if(length(r) > 1)
    p_m = round(mean([r,c]));
   else
       p_m = [r,c];
   end
   CP(p_m(1),p_m(2)) = 1;
end

%Find the extent of the control points
[r_,c_] = find(CP == 1);
minR = min(r_)-10;
maxR = max(r_)+10;
minC = min(c_)-10;
maxC = max(c_)+10;

if(minR < 1)
    minR = 1;
end
if(minC < 1)
    minC = 1;
end
if(maxC > C)
    maxC = C;
end
if(maxR > R)
    maxR = R;
end

%Crop the image
I = I_orig(minR:maxR,minC:maxC,:);
I_ef = I_ef(minR:maxR,minC:maxC,:);
M = M(minR:maxR,minC:maxC,:);

end