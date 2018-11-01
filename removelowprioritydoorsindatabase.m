% ee368 Spring 2010
% Line Database Functions
function [outputmatrix] = removelowprioritydoorsindatabase(linematrix,doorlinematrix,myheight,mywidth)

  % Function expects doorlinematrix is a matrix of 7 columns with each row
  % sorted from maximum to minimum metric value
  % [left-vertical-line-number right-vertical-line-number lowest-horizontal-line-number highest-horizontal-line-number ...
  %  vertical-line-metric-score lowest-line-metric-score highest-line-metric-score]
  
  doorprioritymatrix=[];
  finaldoorlinematrix=[];
  for myi=1:size(doorlinematrix,1)
    myokay = 1;
    if (doorlinematrix(myi,6) < doorlinematrix(myi,5)/4) || ...
       (doorlinematrix(myi,7) < doorlinematrix(myi,5)/4)
      myokay = 0;
    end
    for myj=1:size(doorprioritymatrix)
      if (sum(doorprioritymatrix(myj,1:3)) == sum(doorlinematrix(myi,1:3))) || ...
         (sum([doorprioritymatrix(myj,1) doorprioritymatrix(myj,3:4)]) == sum([doorlinematrix(myi,1) doorlinematrix(myi,3:4)])) || ...
         (sum([doorprioritymatrix(myj,1:2) doorprioritymatrix(myj,4)]) == sum([doorlinematrix(myi,1:2) doorlinematrix(myi,4)])) || ...
         (sum(doorprioritymatrix(myj,2:4)) == sum(doorlinematrix(myi,2:4)))
        myokay = 0;
      elseif ((doorlinematrix(myi,3) == -2) || (doorlinematrix(myi,4) == -2)) && ...
             (doorprioritymatrix(myj,3) ~= -2) && (doorprioritymatrix(myj,4) ~= -2)
        myokay = 0;
      else
        currminx=(linematrix(doorlinematrix(myi,1),1)+linematrix(doorlinematrix(myi,1),2))/2;
        currmaxx=(linematrix(doorlinematrix(myi,2),1)+linematrix(doorlinematrix(myi,2),2))/2;
        if (doorlinematrix(myi,3) ~= -2)
          currminy=(linematrix(doorlinematrix(myi,3),3)+linematrix(doorlinematrix(myi,3),4))/2;
        else
          currminy=1;
        end
        if (doorlinematrix(myi,4) ~= -2)
          currmaxy=(linematrix(doorlinematrix(myi,4),3)+linematrix(doorlinematrix(myi,4),4))/2;
        else
          currmaxy=myheight;
        end
        overlapminx=(linematrix(doorprioritymatrix(myj,1),1)+linematrix(doorprioritymatrix(myj,1),2))/2;
        overlapmaxx=(linematrix(doorprioritymatrix(myj,2),1)+linematrix(doorprioritymatrix(myj,2),2))/2;
        if (doorprioritymatrix(myj,3) ~= -2)
          overlapminy=(linematrix(doorprioritymatrix(myj,3),3)+linematrix(doorprioritymatrix(myj,3),4))/2;
        else
          overlapminy=1;
        end
        if (doorprioritymatrix(myj,4) ~= -2)
          overlapmaxy=(linematrix(doorprioritymatrix(myj,4),3)+linematrix(doorprioritymatrix(myj,4),4))/2;
        else
          overlapmaxy=myheight;
        end
        currarea=(currmaxx-currminx)*(currmaxy-currminy);
        if (currminx > overlapminx)
          overlapminx = currminx;
        end
        if (currmaxx < overlapmaxx)
          overlapmaxx = currmaxx;
        end
        if (currminy > overlapminy)
          overlapminy = currminy;
        end
        if (currmaxy < overlapmaxy)
          overlapmaxy = currmaxy;
        end
        overlaparea=(overlapmaxx-overlapminx)*(overlapmaxy-overlapminy);
        if (overlapmaxx > overlapminx) && (overlapmaxy > overlapminy) && ...
           (overlaparea > (0.5*currarea))
          myokay = 0;
        end
     end
    end
    if myokay
      doorprioritymatrix(size(doorprioritymatrix,1)+1,1:7)=doorlinematrix(myi,1:7);
      finaldoorlinematrix(size(finaldoorlinematrix,1)+1,1:7)=doorlinematrix(myi,1:7);
    end
  end
  
  outputmatrix=finaldoorlinematrix;  
end
