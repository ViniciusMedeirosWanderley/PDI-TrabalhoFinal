% ee368 Spring 2010
% Line Database Functions
function [outputmatrix] = addlinetolinedatabase(linevector,linematrix)

  % Function expects linevector of the following form
  % [minimum x-value maximum x-value minimum y-value maximum y-value hough rho-value hough theta-value]
  %
  % Function expects linematrix is a matrix of 6 columns with each row
  % defining a line as above.

%  linematrix=linematrix
%  linevector=linevector
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
      if ((theta > linevector(6)-5) && (theta < linevector(6)+5)) && ...
         ((rho > linevector(5)-7) && (rho < linevector(5)+7))
%        'Yo Im here 1'
        if ((minx <= linevector(1)) && (maxx >= linevector(2))) && ...
           ((theta < -45) || (theta > 45))
%          rho = (rho + newlinevector(5))/2;
%          theta = (theta + newlinevector(6))/2;
%          newlinevector = [minx maxx miny maxy rho theta];
%          linematrix(myi,1:6) = [minx maxx miny maxy rho theta];
%          myi=myi
%          'Combined a line'
          combinelines = [combinelines myi];
        elseif ((miny <= linevector(3)) && (maxy >= linevector(4))) && ...
               ((theta >=-45) && (theta <= 45))
%          rho = (rho + newlinevector(5))/2;
%          theta = (theta + newlinevector(6))/2;
%          newlinevector = [minx maxx miny maxy rho theta];
%          linematrix(myi,1:6) = [minx maxx miny maxy rho theta];
%          myi=myi
          combinelines = [combinelines myi];
        elseif ((linevector(1) < minx) && (linevector(2) > maxx)) || ...
               ((linevector(3)< miny) && (linevector(4) > maxy))
          combinelines = [combinelines myi];
        elseif (((minx < linevector(1)) && (maxx > linevector(1)-40)) || ...
                ((maxx > linevector(2)) && (minx < linevector(2)+40))) && ...
               ((theta < -45) || (theta > 45))
          combinelines = [combinelines myi];
        elseif (((miny < linevector(3)) && (maxy > linevector(3)-40)) || ...
                ((maxy > linevector(4)) && (miny < linevector(4)+40))) && ...
               ((theta >=-45) && (theta <= 45))
          combinelines = [combinelines myi];
        end     
      end
    end
    
%    combinelines=combinelines
    myj=length(combinelines);
    finalline=linevector;
    while (myj > 0)
%   Add line to database if no combinations found
      if (combinelines(myj) == 0) && (length(combinelines) == 1)
        outputmatrix=linematrix;
        outputmatrix(1,1:6)=[numberoflines+1 0 0 0 0 0];
        outputmatrix(numberoflines+2,1:6)=finalline;
%   Add combined line to end of database
      elseif (combinelines(myj) == 0) && (length(combinelines) > 1)
        linematlastline=2;
        outmatlastline=2;
        mycount=0;
        for myi=2:length(combinelines)
          linematcurrline=sign(combinelines(myi))*combinelines(myi);
          outmatcurrline=sign(combinelines(myi))*combinelines(myi) - mycount;
          if (linematcurrline ~= 2)
            outputmatrix(outmatlastline:outmatcurrline,1:6)=linematrix(linematlastline:linematcurrline,1:6);
          end
          linematlastline=linematcurrline+1;
          outmatlastline=outmatcurrline;
          mycount = mycount+1;
        end
        linematcurrline=size(linematrix,1);
        outmatcurrline=size(linematrix,1) - mycount;
        outputmatrix(outmatlastline:outmatcurrline,1:6)=linematrix(linematlastline:linematcurrline,1:6);
        outputmatrix(1,1:6)=[numberoflines+1 0 0 0 0 0];
        outputmatrix(numberoflines+2,1:6)=[finalline];
%   Combine lines that were identified as extensions
      elseif (combinelines(myj) > 0)
        myi = combinelines(myj);
        currline = linematrix(myi,1:6);
        if currline(1) < finalline(1)
          finalline(1) = currline(1);
        end
        if currline(2) > finalline(2)
          finalline(2) = currline(2);
        end
        if currline(3) < finalline(3)
          finalline(3) = currline(3);
        end
        if currline(4) > finalline(4)
          finalline(4) = currline(4);
        end
        finalline(5) = (currline(5)+finalline(5))/2;
        finalline(6) = (currline(6)+finalline(6))/2;
        numberoflines=numberoflines-1;
        outputmatrix(1,1:6)=[numberoflines 0 0 0 0 0];

%   Skip placeholder in combine lines vector
      else
        numberoflines=numberoflines-1;
        outputmatrix(1,1:6)=[numberoflines 0 0 0 0 0];
%        outputmatrix=linematrix;
      end
      myj=myj-1;
    end
  end
    
end
