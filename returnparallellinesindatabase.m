% ee368 Spring 2010
% Line Database Functions
function [outputmatrix] = returnparallellinesindatabase(linematrix)

  % Function expects linematrix is a matrix of 6 columns with each row
  % [minimum x-value maximum x-value minimum y-value maximum y-value hough rho-value hough theta-value]

%  linematrix=linematrix
%  linevector=linevector
%  Order vertical lines by size
  numberoflines = linematrix(1,1);
  lineorder=[];
  for myi = 2:numberoflines+1
    newlength=linematrix(myi,4)-linematrix(myi,3);
    theta=linematrix(myi,6);
%    'Yo Im here 2'
    if ((theta >=-45) && (theta <= 45) && newlength > 80)
      myj = 1;
      if length(lineorder) > 0
        oldlength = linematrix(lineorder(myj),4)-linematrix(lineorder(myj),3);
      end
      while (myj <= length(lineorder)) && (oldlength > newlength)
        myj=myj+1;
        if (myj <= length(lineorder))
          oldlength = linematrix(lineorder(myj),4)-linematrix(lineorder(myj),3);
        end
      end
      if (length(lineorder) > 0) && (myj <= length(lineorder))
        clear hold;
        hold = lineorder(1:myj-1);
        hold(myj) = myi;
        hold(myj+1:length(lineorder)+1) = lineorder(myj:length(lineorder));
        lineorder = hold;
      else
        lineorder = [lineorder myi];
      end
    end
  end
  
%  linelengths = [];
%  lineorder = lineorder
%  for myi=1:length(lineorder);
%    newlength=linematrix(lineorder(myi),4)-linematrix(lineorder(myi),3);
%    linelengths(myi) = newlength;
%  end
%  linelengths = linelengths

  ordermatrix=[];
  ordercount=1;
  for myi = 1:length(lineorder)
    majorminy=linematrix(lineorder(myi),3);
    majormaxy=linematrix(lineorder(myi),4);
    majorlength=majormaxy-majorminy;
    majorminx=linematrix(lineorder(myi),1);
    majortheta=linematrix(lineorder(myi),6);
    for myj = 1:length(lineorder)
      if (myj > myi)
        newminy=linematrix(lineorder(myj),3);
        newmaxy=linematrix(lineorder(myj),4);
        newlength=newmaxy-newminy;
        newminx=linematrix(lineorder(myj),1);
        newtheta=linematrix(lineorder(myj),6);
        if (((newminx < majorminx-(majorlength/3)) && (newminx > majorminx-(majorlength/1.4))) || ...
            ((newminx > majorminx+(majorlength/3)) && (newminx < majorminx+(majorlength/1.4)))) && ...
           ((newtheta > majortheta - 5) || (newtheta < majortheta+5))
          metadd=200/(abs((majorlength/2.2)-abs(newminx-majorminx)));
          if metadd > 200
            metadd=200;
          end
%          metadd
          metric = max([majorlength newlength])-(abs(newlength-majorlength))-abs(newminy-majorminy)-abs(newmaxy-majormaxy)+metadd;
          myk = 1;
          if size(ordermatrix,1) > 0
            oldmetric = ordermatrix(myk,3);
          end
          while (myk <= size(ordermatrix,1)) && (oldmetric > metric)
            myk=myk+1;
            if (myk <= size(ordermatrix,1))
              oldmetric = ordermatrix(myk,3);
            end
          end
          if (size(ordermatrix,1) > 0) && (myk <= size(ordermatrix,1))
            clear holdmatrix;
            holdmatrix = ordermatrix(1:myk-1,1:3);
            holdmatrix(myk,1:3) = [lineorder(myi) lineorder(myj) metric];
            holdmatrix(myk+1:size(ordermatrix,1)+1,1:3) = ordermatrix(myk:size(ordermatrix,1),1:3);
            ordermatrix = holdmatrix;
          else
            ordermatrix(size(ordermatrix,1)+1,1:3) = [lineorder(myi) lineorder(myj) metric];
          end
        end
      end
    end
  end
  outputmatrix=ordermatrix;
    
end
