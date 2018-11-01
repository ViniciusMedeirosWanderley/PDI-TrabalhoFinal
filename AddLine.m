function [I] = AddLine(I,x1,y1,x2,y2)

[r,c] = size(I);              %# Get the image size 
rpts = linspace(x1,x2,1000);   %# A set of row points for the line 
cpts = linspace(y1,y2,1000);   %# A set of column points for the line 
index = sub2ind([r c],round(rpts),round(cpts));  %# Compute a linear index 
I(index) = I(index) + 1;               %# Set the line points to white 


end