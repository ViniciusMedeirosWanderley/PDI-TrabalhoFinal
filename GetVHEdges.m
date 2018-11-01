function [I_v,I_h] = GetVHEdges(I_g)

lf = [-1 1];

I_gv = imfilter(I_g,ones(10,2));
I_gh = imfilter(I_g,ones(2,10));
I_v = abs(imfilter(I_gv,lf,'symmetric'));
I_h = abs(imfilter(I_gh,lf','symmetric'));

%I_v(I_v < 0.05*max(I_v(:))) = 0;
%I_v(I_v > 0) = 1;
I_v = edge(I_v,'canny',0.1);

%I_h(I_h < 0.05*max(I_h(:))) = 0;
%I_h(I_h > 0) = 1;
I_h = edge(I_h,'canny',0.1);

%I_vl = imresize(I_v,size(I_v)*1/2,'nearest');
%I_vl = imresize(I_vl,size(I_g),'nearest');
I_v = RemoveSmallRegions(I_v,20);

%I_hl = imresize(I_h,size(I_h)*1/2,'nearest');
%I_hl = imresize(I_hl,size(I_g),'nearest');
I_h = RemoveSmallRegions(I_h,10);

end