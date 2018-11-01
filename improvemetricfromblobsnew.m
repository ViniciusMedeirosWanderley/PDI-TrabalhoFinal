% ee368 Spring 2010
% Line Database Functions
function [outputmatrix,outblobmatrix,outblobcount] = improvemetricfromblobs(linematrix,blobmatrix,blobcount,hingematrix,doorlinematrix)

  % Function expects linematrix is a matrix of 6 columns with each row
  % [minimum x-value maximum x-value minimum y-value maximum y-value hough rho-value hough theta-value]
  %
  % Function expects parallellinematrix is a matrix of 3 columns with each row
  % sorted from maximum to minimum metric value
  % [first-line-number second-line-number parallel-metric-value]

  if (size(doorlinematrix,1) > 0)
  mywidth=size(hingematrix,2);
  myheight=size(hingematrix,1);
  
%  Boost lines close to door handles
  maxparametric=doorlinematrix(1,5)
  maxregioncount=0.4*maxparametric;
  minregioncount=0.1*maxparametric;
  regionstodelete = find((blobcount < minregioncount) | (blobcount > maxregioncount));
  for myi = regionstodelete'
    blobcount(myi) = 0;
    [regionrowvec regioncolumnvec]=find(blobmatrix==myi);
    for myj = 1:length(regionrowvec)
      blobmatrix(regionrowvec(myj),regioncolumnvec(myj)) = 0;
    end
  end
  
  boostmatrix=[];
  for myi=1:length(blobcount)
    closestline=[-1 -1];
    closestdistance=200;
    if (blobcount(myi) ~= 0)
      [regionrowvec regioncolumnvec]=find(blobmatrix==myi);
      blobxavg=(min(regioncolumnvec)+max(regioncolumnvec))/2;
      blobyavg=(min(regionrowvec)+max(regionrowvec))/2;
      if length(blobyavg) > 0
        okay = 1;
      else
        okay = 0;
      end
      if (size(boostmatrix,1) > 0)
        allxavg=boostmatrix(:,3);
        allyavg=boostmatrix(:,4);
        xindex = find((allxavg > blobxavg -40) & (allxavg < blobxavg + 40));
%        yindex = find((allyavg > blobyavg -40) & (allyavg < blobyavg + 40));
%        for myi = xindex'
%          if (length(find(yindex == myi)) > 0)
          if (length(xindex) > 0)
            okay = 0;
          end
%        end
      end
%      okay
%      boostmatrix
      if (okay)
        for myj=1:size(doorlinematrix,1)
          leftlinexavg=(linematrix(doorlinematrix(myj,1),1)+linematrix(doorlinematrix(myj,1),2))/2;
          rightlinexavg=(linematrix(doorlinematrix(myj,2),1)+linematrix(doorlinematrix(myj,2),2))/2;
          if doorlinematrix(myj,3) ~= -2
            toplineyavg=(linematrix(doorlinematrix(myj,3),3)+linematrix(doorlinematrix(myj,3),4))/2;
          else
            toplineyavg=1;
          end
          if doorlinematrix(myj,4) ~= -2
            botlineyavg=(linematrix(doorlinematrix(myj,4),3)+linematrix(doorlinematrix(myj,4),4))/2;
          else
            botlineyavg=myheight;
          end
          width=rightlinexavg-leftlinexavg;
          height=botlineyavg-toplineyavg;
          botlimit=height/4;
          toplimit=height/2;
          if doorlinematrix(myj,3) == -2
            toplimit = height/4;
          end
          if doorlinematrix(myj,4) == -2
            botlimit = 0;
          end
          blobyavg
          toplineyavg
          toplimit
          botlineyavg
          botlimit
          if (blobyavg > toplineyavg + toplimit) && (blobyavg < botlineyavg - botlimit)
            currcloseness=-10;
            if ((blobxavg < rightlinexavg) && (blobxavg > leftlinexavg + (7/8)*width))
              currcloseness=rightlinexavg-blobxavg;
              currcloseline=[doorlinematrix(myj,2) 2 blobxavg blobyavg];
            elseif ((blobxavg > leftlinexavg) && (blobxavg < rightlinexavg - (7/8)*width))
              currcloseness=blobxavg-leftlinexavg;
              currcloseline=[doorlinematrix(myj,1) 1 blobxavg blobyavg];
            end
            if (currcloseness >= 0) && (currcloseness < closestdistance)
              closestdistance = currcloseness;
              closestline = currcloseline;
            end
          end
        end
      end
%      closestline
      if (closestline(1) > 0)
        boostmatrix=[boostmatrix; closestline];
      end
    end
  end

  boostmatrix=boostmatrix
  for myi=1:size(boostmatrix,1)
    for myj=1:size(doorlinematrix,1)
      leftline=doorlinematrix(myj,1);
      rightline=doorlinematrix(myj,2);
      if ((boostmatrix(myi,1) == leftline) && (boostmatrix(myi,2) == 1)) || ...
         ((boostmatrix(myi,1) == rightline) && (boostmatrix(myi,2) == 2))
        doorlinematrix(myj,6)=doorlinematrix(myj,6)+((doorlinematrix(myj,5)-doorlinematrix(myj,6))/2);
        doorlinematrix(myj,7)=doorlinematrix(myj,7)+((doorlinematrix(myj,5)-doorlinematrix(myj,7))/2);
      end
    end
  end
  
%  Boost lines close enough to hinges
  boostmatrix=[];
  closevalue=7;
  leftlinenums=unique(doorlinematrix(:,1)');
  rightlinenums=unique(doorlinematrix(:,2)');
  linenums(1:length(leftlinenums))=leftlinenums;
  linenums(length(leftlinenums)+1:length(leftlinenums)+length(rightlinenums))=rightlinenums;
  [picmatrix1,countvector]=regioncount(hingematrix.*255);
  for myi=1:length(countvector)
    [regionrowvec regioncolumnvec]=find(picmatrix1==myi);
    miny=min(regionrowvec);
    maxy=max(regionrowvec);
    xhingeavg=(min(regioncolumnvec)+max(regioncolumnvec))/2;
    for linenum=linenums
      rho=linematrix(linenum,5);
      theta=linematrix(linenum,6);
      if ((theta >=-90) & (theta < 0))
        otherangle=90+theta;
      elseif (theta > 0)
        otherangle=-90+theta;
      else
        otherangle=0;
      end
      m=tand(otherangle);
      b=sind(theta)*rho-1*tand(otherangle)*cosd(theta)*rho;
      yes=miny:maxy;
      xes=round((yes-b)./m);
      lineminx=min(xes);
      if lineminx <= 0
        lineminx = 1;
      end
      linemaxx=max(xes);
      if linemaxx > mywidth
        linemaxx = mywidth;
      end
      lineavg=((lineminx+linemaxx)/2);
      currcloseness=abs(xhingeavg-lineavg);
      if (currcloseness <= closevalue)
        boostmatrix(length(boostmatrix)+1)=linenum;
      end
    end
  end
  
  boostmatrix=boostmatrix
  for myi=boostmatrix
    leftindexes=find(doorlinematrix(:,1) == myi);
    for myj=leftindexes'
      doorlinematrix(myj,6)=doorlinematrix(myj,6)+((doorlinematrix(myj,5)-doorlinematrix(myj,6))/6);
      doorlinematrix(myj,7)=doorlinematrix(myj,7)+((doorlinematrix(myj,5)-doorlinematrix(myj,7))/6);
    end
    rightindexes=find(doorlinematrix(:,2) == myi);
    for myj=rightindexes'
      doorlinematrix(myj,6)=doorlinematrix(myj,6)+((doorlinematrix(myj,5)-doorlinematrix(myj,6))/6);
      doorlinematrix(myj,7)=doorlinematrix(myj,7)+((doorlinematrix(myj,5)-doorlinematrix(myj,7))/6);
    end
  end
    
  finaldoorlinematrix=[];
  for myi = 1:size(doorlinematrix,1)
%    doorlinematrix(myi,1:7)
    if size(finaldoorlinematrix,1) == 0
      finaldoorlinematrix(1,1:7)=doorlinematrix(myi,1:7);
    else
      sortmetric=sum(doorlinematrix(myi,5:7));
      myj=1;
      currmetric=sum(finaldoorlinematrix(myj,5:7));
      while (myj<=size(finaldoorlinematrix,1)) && (sortmetric < currmetric)
        myj=myj+1;
        if myj<=size(finaldoorlinematrix,1)
          currmetric=sum(finaldoorlinematrix(myj,5:7));
        end
      end
      finaldoorlinematrix(myj+1:size(finaldoorlinematrix,1)+1,1:7)=finaldoorlinematrix(myj:size(finaldoorlinematrix,1),1:7);
      finaldoorlinematrix(myj,1:7)=doorlinematrix(myi,1:7);
    end
  end

  else
    finaldoorlinematrix=doorlinematrix;
  end
  outblobcount=blobcount;
  outblobmatrix=blobmatrix;
  outputmatrix=finaldoorlinematrix;  
end
