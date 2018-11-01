%Computes corners using vert/horz line crossings and line strength
function [CP,I_] = CornerDetect(I_ef,N_max,N_min)
           
[R C] = size(I_ef);

I_cnt_v = zeros(R,C);
I_cnt_h = zeros(R,C);

%Sum up columns
for c = 1:C
    for r = 2:R
        I_cnt_v(r,c) = I_ef(r,c).*(I_cnt_v(r-1,c)+2);
    end
end

%Mark all columns with max value in string of 1s
R_rv = fliplr(1:R);
val = 1;
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

%Sum up rows
for r = 1:R
    for c = 2:C
        I_cnt_h(r,c) = I_ef(r,c).*(I_cnt_h(r,c-1)+1);
    end
end

%Mark all rows with max value in string of 1s
C_rv = fliplr(1:C);
val = 1;
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

%Computer corners
I_cnt_h = imdilate(I_cnt_h,ones(1,10));
I_cnt_v = imdilate(I_cnt_v,ones(20,1));
I = I_cnt_h.^2.*I_cnt_v.^2;
I_ = I;

%Pick top 250
I_s = sort(I(:));
I_hist = hist(I(:),100);
cnt = sum(I_hist(5:100));
if(cnt > N_max)
    cnt = N_max;
end
if(cnt < N_min)
    cnt = N_min;
end
I(I < I_s(length(I_s)-cnt)) = 0;
I(I > 0) = 1;

%Dilate to combine neighbors
I = imdilate(I,ones(5,5));

%Mark corners as the center of each region
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

end

% %Computes corners using vert/horz line crossings and line strength
% function [CP,I_] = CornerDetect(I_ef,N_max,N_min)
%            
% [R C] = size(I_ef);
% 
% I_cnt_v = zeros(R,C);
% I_cnt_h = zeros(R,C);
% 
% %Sum up columns
% for c = 1:C
%     for r = 2:R
%         I_cnt_v(r,c) = I_ef(r,c).*(I_cnt_v(r-1,c)+5);
%     end
% end
% 
% %Mark all columns with max value in string of 1s
% R_rv = fliplr(1:R);
% val = 1;
% for c = 1:C
%     for r = 1:length(R_rv)
%         if(I_cnt_v(R_rv(r),c) >= 1)
%             if(val == 1)
%                 val = I_cnt_v(R_rv(r),c);
%             else
%                 I_cnt_v(R_rv(r),c) = val;
%             end
%         else
%             val = 1;
%         end
%     end
% end
% 
% %Sum up rows
% for r = 1:R
%     for c = 2:C
%         I_cnt_h(r,c) = I_ef(r,c).*(I_cnt_h(r,c-1)+5);
%     end
% end
% 
% %Mark all rows with max value in string of 1s
% C_rv = fliplr(1:C);
% val = 1;
% for r = 1:R
%     for c = 1:length(C_rv)
%         if(I_cnt_h(r,C_rv(c)) >= 1)
%             if(val == 1)
%                 val = I_cnt_h(r,C_rv(c));
%             else
%                 I_cnt_h(r,C_rv(c)) = val;
%             end
%         else
%             val = 1;
%         end
%     end
% end
% 
% %Computer corners
% I = I_cnt_h.*I_cnt_v;
% I_ = I;
% 
% %Pick top 250
% I_s = sort(I(:));
% I_hist = hist(I(:),100);
% cnt = sum(I_hist(10:100));
% if(cnt > N_max)
%     cnt = N_max;
% end
% if(cnt < N_min)
%     cnt = N_min;
% end
% I(I < I_s(length(I_s)-cnt)) = 0;
% I(I > 0) = 1;
% 
% %Dilate to combine neighbors
% I = imdilate(I,ones(5,5));
% 
% %Mark corners as the center of each region
% LBL = bwlabel(I);
% u = unique(LBL(:));
% CP = zeros(size(LBL));
% for i = 1:length(u)
%    [r,c] = find(LBL == u(i));
%    if(length(r) > 1)
%     p_m = round(mean([r,c]));
%    else
%        p_m = [r,c];
%    end
%    CP(p_m(1),p_m(2)) = 1;
% end
% 
% end