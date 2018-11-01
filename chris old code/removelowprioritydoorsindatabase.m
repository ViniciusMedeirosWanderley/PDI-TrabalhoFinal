% ee368 Spring 2010
% Line Database Functions
function [outputmatrix] = removelowprioritydoorsindatabase(doorlinematrix)

  % Function expects doorlinematrix is a matrix of 7 columns with each row
  % sorted from maximum to minimum metric value
  % [left-vertical-line-number right-vertical-line-number lowest-horizontal-line-number highest-horizontal-line-number ...
  %  vertical-line-metric-score lowest-line-metric-score highest-line-metric-score]
  
  doorprioritymatrix=[];
  finaldoorlinematrix=[];
  for myi=1:size(doorlinematrix,1)
    myokay = 1;
    if (doorlinematrix(myi,6) < doorlinematrix(myi,5)/5) || ...
       (doorlinematrix(myi,7) < doorlinematrix(myi,5)/5)
      myokay = 0;
    end
    for myj=1:size(doorprioritymatrix)
      if (sum(doorprioritymatrix(myj,1:3)) == sum(doorlinematrix(myi,1:3))) || ...
         (sum([doorprioritymatrix(myj,1) doorprioritymatrix(myj,3:4)]) == sum([doorlinematrix(myi,1) doorlinematrix(myi,3:4)])) || ...
         (sum([doorprioritymatrix(myj,1:2) doorprioritymatrix(myj,4)]) == sum([doorlinematrix(myi,1:2) doorlinematrix(myi,4)])) || ...
         (sum(doorprioritymatrix(myj,2:4)) == sum(doorlinematrix(myi,2:4)))
        myokay = 0;
      end
    end
    if myokay
      doorprioritymatrix(size(doorprioritymatrix,1)+1,1:7)=doorlinematrix(myi,1:7);
      finaldoorlinematrix(size(finaldoorlinematrix,1)+1,1:7)=doorlinematrix(myi,1:7);
    end
  end
  
  outputmatrix=finaldoorlinematrix;  
end
