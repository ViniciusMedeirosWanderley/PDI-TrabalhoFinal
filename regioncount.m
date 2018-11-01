% ee368 Spring 2010
% Region Counting Function
function [outputpicmatrix,countvector] = regioncount(inputpicmatrix)

  [outputpicmatrix,n] = bwlabeln(im2bw(inputpicmatrix));

  countvector = zeros(n,1);
  for i =  1:n
    countvector(i) = sum(sum(outputpicmatrix(outputpicmatrix == i)))./i;
  end

end
