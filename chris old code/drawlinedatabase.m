% ee368 Spring 2010
% Line Database Functions
function [outputmatrix] = drawlinedatabase(linematrix,myheight,mywidth)

  % Function expects linematrix is a matrix of 6 columns with each row
  % defined as:
  % [minimum x-value maximum x-value minimum y-value maximum y-value hough rho-value hough theta-value]

  outputmatrix=zeros(myheight,mywidth);

  if (size(linematrix,1) > 0)
    for myi=2:linematrix(1,1)+1
 %     linematrix(myi,1:6)
      minx=linematrix(myi,1);
      maxx=linematrix(myi,2);
      miny=linematrix(myi,3);
      maxy=linematrix(myi,4);
      rho=linematrix(myi,5);
      theta=linematrix(myi,6);
      if ((theta >=-90) & (theta < 0))
        otherangle=90+theta;
      elseif (theta > 0)
        otherangle=-90+theta;
      else
        otherangle=0;
      end
      m=tand(otherangle);
      b=sind(theta)*rho-1*tand(otherangle)*cosd(theta)*rho;
      if ((theta > -45) & (theta < 45))
        flag=0;
        yes=miny:maxy;
        xes=round((yes-b)./m);
%        mymat(1,1:length(yes))=yes;
%        mymat(2,1:length(yes))=xes
        for myj=miny:maxy
          if (m == 0)
            currx=minx;
          else
            currx=round((myj-b)/m);
          end
          if (currx > 0) && (currx <= mywidth)
            outputmatrix(myj,currx)=255;
          elseif (currx <= 0)
            outputmatrix(myj,1)=255;
          elseif (currx > mywidth)
            outputmatrix(myj,mywidth)=255;
%          elseif (flag == 0)
%            sprintf('not drawing m= %5.2f, b=%5.2f, theta= %5.2f, rho= %5.2f',m,b,theta,rho)
%            flag = 1;
          end
        end
        clear mymat;
      else
        flag=0;
        xes=minx:maxx;
        yes=round(m.*xes+b);
        for myj=minx:maxx
          curry=round(m*myj+b);
          if (curry > 0) && (curry <= myheight)
            outputmatrix(curry,myj)=255;
          elseif (curry <= 0)
            outputmatrix(1,myj)=255;
          elseif (curry > myheight)
            outputmatrix(myheight,myj)=255;
%          elseif (flag == 0)
%            sprintf('not drawing m= %5.2f, b=%5.2f, theta= %5.2f, rho= %5.2f',m,b,theta,rho)
%            flag = 1;
          end
        end
      end
    end
  end
    
end
