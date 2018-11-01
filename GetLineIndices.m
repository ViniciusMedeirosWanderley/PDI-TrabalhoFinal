function [LI] = GetLineIndices(I,p1,p2)

[r,c] = size(I);              %# Get the image size 
rpts = linspace(p1(1),p2(1),1000);   %# A set of row points for the line 
cpts = linspace(p1(2),p2(2),1000);   %# A set of column points for the line 
LI = sub2ind([r c],round(rpts),round(cpts));  %# Compute a linear index 

end