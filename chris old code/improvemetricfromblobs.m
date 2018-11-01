% ee368 Spring 2010
% Line Database Functions
function [outputmatrix] = improvemetricfromblobs(linematrix,blobmatrix,blobcount,hingematrix,doorlinematrix)

  % Function expects linematrix is a matrix of 6 columns with each row
  % [minimum x-value maximum x-value minimum y-value maximum y-value hough rho-value hough theta-value]
  %
  % Function expects parallellinematrix is a matrix of 3 columns with each row
  % sorted from maximum to minimum metric value
  % [first-line-number second-line-number parallel-metric-value]

  mywidth=size(hingematrix,2);
  myheight=size(hingematrix,1);
%  linematrix=linematrix
%  linevector=linevector
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

  boostmatrix
  for myi=boostmatrix
    leftindexes=find(doorlinematrix(:,1) == myi);
    for myj=leftindexes'
      doorlinematrix(myj,6)=doorlinematrix(myj,6)+((doorlinematrix(myj,5)-doorlinematrix(myj,6))/8);
      doorlinematrix(myj,7)=doorlinematrix(myj,7)+((doorlinematrix(myj,5)-doorlinematrix(myj,7))/8);
    end
    rightindexes=find(doorlinematrix(:,2) == myi);
    for myj=rightindexes'
      doorlinematrix(myj,6)=doorlinematrix(myj,6)+((doorlinematrix(myj,5)-doorlinematrix(myj,6))/8);
      doorlinematrix(myj,7)=doorlinematrix(myj,7)+((doorlinematrix(myj,5)-doorlinematrix(myj,7))/8);
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
      finaldoorlinematrix(myj,1:7)=doorlinematrix(myi,1:7)
    end
  end
%  while (currmetric > 0) && (currmetric > 0.8*maxmetric) && (myj < size(parallellinematrix,1)-1)
%    if (linematrix(parallellinematrix(myj,1),1) < linematrix(parallellinematrix(myj,2),1))
%      currminx=linematrix(parallellinematrix(myj,1),1);
%      currmaxx=linematrix(parallellinematrix(myj,2),1);
%      xorder=[parallellinematrix(myj,1) parallellinematrix(myj,2)];
%    else
%      currmaxx=linematrix(parallellinematrix(myj,1),1);
%      currminx=linematrix(parallellinematrix(myj,2),1);
%      xorder=[parallellinematrix(myj,2) parallellinematrix(myj,1)];
%    end
%    curravgmaxy=(linematrix(parallellinematrix(myj,1),4)+linematrix(parallellinematrix(myj,2),4))/2;
%    curravgminy=(linematrix(parallellinematrix(myj,1),3)+linematrix(parallellinematrix(myj,2),3))/2;
%    maxymetric=[-100 -2];
%    minymetric=[-100 -2];
%    for myi=1:size(horzmatrix,1)
%      myminx=linematrix(horzmatrix(myi,2),1);
%      mymaxx=linematrix(horzmatrix(myi,2),2);
%      myy=horzmatrix(myi,1);
%      minxerror=0;
%      maxxerror=0;
%      if (myminx > currminx)
%        minxerror=notconnectmult*abs(myminx-currminx);
%      end
%      if (mymaxx < currmaxx)
%        maxxerror=notconnectmult*abs(mymaxx-currmaxx);
%      end
%      currminymetric=0.5*(parallellinematrix(myj,3))-minxerror-maxxerror-(notconnectmult*abs(myy-curravgminy));
%      currmaxymetric=0.5*(parallellinematrix(myj,3))-minxerror-maxxerror-(notconnectmult*abs(myy-curravgmaxy));
%      if (currminymetric > minymetric(1))
%        minymetric = [currminymetric horzmatrix(myi,2)];
%      end
%      if (currmaxymetric > maxymetric(1))
%        maxymetric = [currmaxymetric horzmatrix(myi,2)];
%      end
%    end
%    totalmetric=parallellinematrix(myj,3)+minymetric(1)+maxymetric(1);
%    myk=1;
%    if size(ordermatrix,1) > 0
%      oldmetric = sum(ordermatrix(myk,5:7));
%    end
%    while (myk <= size(ordermatrix,1)) && (oldmetric > totalmetric)
%      myk=myk+1;
%      if (myk <= size(ordermatrix,1))
%        oldmetric = sum(ordermatrix(myk,5:7));
%      end
%    end
%    if (size(ordermatrix,1) > 0) && (myk <= size(ordermatrix,1))
%      clear holdmatrix;
%      holdmatrix = ordermatrix(1:myk-1,1:7);
%      holdmatrix(myk,1:7) = [xorder minymetric(2) maxymetric(2) parallellinematrix(myj,3) minymetric(1) maxymetric(1)];
%      holdmatrix(myk+1:size(ordermatrix,1)+1,1:7) = ordermatrix(myk:size(ordermatrix,1),1:7);
%      ordermatrix = holdmatrix;
%    else
%      ordermatrix(size(ordermatrix,1)+1,1:7) = [xorder minymetric(2) maxymetric(2) parallellinematrix(myj,3) minymetric(1) maxymetric(1)];
%    end
%    myj=myj+1;
%    currmetric=parallellinematrix(myj,3);
%  end
  outputmatrix=finaldoorlinematrix;  
end
