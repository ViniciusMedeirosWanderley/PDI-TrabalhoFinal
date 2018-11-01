% ee368 Spring 2010
% Line Database Functions
function [outputmatrix] = addlinetolinedatabase(linevector,linematrix)

  % Function expects linevector of the following form
  % [minimum x-value maximum x-value minimum y-value maximum y-value hough rho-value hough theta-value]
  %
  % Function expects linematrix is a matrix of 6 columns with each row
  % defining a line as above.

  linematrix=linematrix;
  size(linematrix,1);
  if (size(linematrix,1) == 0)
    outputmatrix(1,1:6)=[1 0 0 0 0 0];
    outputmatrix(2,1:6)=linevector;
  else
    numberoflines = linematrix(1,1);
    combinelines = [0];
    for myi = 2:size(linematrix,1)
      minx=linematrix(myi,1);
      maxx=linematrix(myi,2);
      miny=linematrix(myi,3);
      maxy=linematrix(myi,4);
      rho=linematrix(myi,5);
      theta=linematrix(myi,6);
%      'Yo Im here 2'
      if ((theta > linevector(6)-2) && (theta < linevector(6)+2)) && ...
         ((rho > linevector(5)-8) && (rho < linevector(5)+8))
%        'Yo Im here 1'
        if ((minx < linevector(1)) && (maxx > linevector(2))) || ...
           ((miny < linevector(3)) && (maxy > linevector(4)))
          rho = (rho + linevector(5))/2;
          theta = (theta + linevector(6))/2;
          linematrix(myi,1:6) = [minx maxx miny maxy rho theta];
%          'Combined a line'
          combinelines = [-1];
%        elseif ((minx < linevector(2)+20) || (maxx > linevector(1)-20)) && ...
%               ((theta < -45) || (theta > 45))
%          combinelines = [combinelines myi];
%        elseif ((miny < linevector(4)+20) || (maxx > linevector(3)-20)) && ...
%               ((theta >=-45) && (theta <= 45))
%          combinelines = [combinelines myi];
        end     
      end
    end
    
%    'Yo Im here 3'
    outputmatrix=linematrix;
    myj=length(combinelines);
    finalline=linevector;
    while (myj > 0) && (combinelines(myj) ~= -1)
%   Add line to database if no combinations found
      if (combinelines(myj) == 0) && (length(combinelines) == 1)
        outputmatrix(1,1:6)=[numberoflines+1 0 0 0 0 0];
        outputmatrix(numberoflines+2,1:6)=linevector;
%   Combine lines that were identified as extensions
      elseif (combinelines(myj) > 0)
        currline = linematrix(myi,1:6);
        if currline(1) < finalline(1)
          finalline(1) = currline(1)
        end
        if currline(2) > finalline(2)
          finalline(2) = currline(2)
        end
        if currline(3) < finalline(3)
          finalline(3) = currline(3)
        end
        if currline(4) > finalline(4)
          finalline(4) = currline(4)
        end
        finalline(5) = (currline(5)+finalline(5))/2;
        finalline(6) = (currline(6)+finalline(6))/2;
        if (length(combinelines)-1 > 1)
          outputmatrix(myi:(size(outputmatrix,1)-1),1:6)=outputmatrix(myi+1:size(outputmatrix,1),1:6);
        else
          outputmatrix(myi:(size(outputmatrix,1)),1:6)=[finalline; outputmatrix(myi+1:size(outputmatrix,1),1:6)];
        end
        combinelines=combinelines(1:length(combinelines-1))
%   Skip placeholder in combine lines vector
      else
      end
      myj=myj-1;
    end
  end

    
end
