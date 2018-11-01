% ee368 Spring 2010
% Line Database Functions
function [outputmatrix] = finddoorendsindatabase(linematrix,parallellinematrix,notconnectmult)

  % Function expects linematrix is a matrix of 6 columns with each row
  % [minimum x-value maximum x-value minimum y-value maximum y-value hough rho-value hough theta-value]
  %
  % Function expects parallellinematrix is a matrix of 3 columns with each row
  % sorted from maximum to minimum metric value
  % [first-line-number second-line-number parallel-metric-value]

%  linematrix=linematrix
%  linevector=linevector
%  Order horizontal lines by average y-value
%  notconnectmult=5;
  numberoflines = linematrix(1,1);
  horzmatrix=[];
  for myi = 2:numberoflines+1
    newavgy=(linematrix(myi,4)+linematrix(myi,3))/2;
    theta=linematrix(myi,6);
%    'Yo Im here 2'
    if (theta < -45) || (theta > 45)
      myj = 1;
      if size(horzmatrix,1) > 0
        oldavgy = horzmatrix(myj,1);
      end
      while (myj <= size(horzmatrix,1)) && (oldavgy > newavgy)
        myj=myj+1;
        if (myj <= size(horzmatrix,1))
          oldavgy = horzmatrix(myj,1);
        end
      end
      if (size(horzmatrix,1) > 0) && (myj <= size(horzmatrix,1))
        clear holdmatrix;
        holdmatrix = horzmatrix(1:myj-1,1:2);
        holdmatrix(myj,1:2) = [newavgy myi];
        holdmatrix(myj+1:size(horzmatrix,1)+1,1:2) = horzmatrix(myj:size(horzmatrix,1),1:2);
        horzmatrix = holdmatrix;
      else
        horzmatrix(size(horzmatrix,1)+1,1:2) = [newavgy myi];
      end
    end
  end
  
%  linelengths = [];
  horzmatrix = horzmatrix
%  for myi=1:length(lineorder);
%    newlength=linematrix(lineorder(myi),4)-linematrix(lineorder(myi),3);
%    linelengths(myi) = newlength;
%  end
%  linelengths = linelengths

  myj=1;
  ordermatrix=[];
  if(~isempty(parallellinematrix))
  maxmetric=parallellinematrix(myj,3);
  currmetric=parallellinematrix(myj,3);
  while (currmetric > 0) && (currmetric > 0.8*maxmetric) && (myj < size(parallellinematrix,1)-1)
    if (linematrix(parallellinematrix(myj,1),1) < linematrix(parallellinematrix(myj,2),1))
      currminx=linematrix(parallellinematrix(myj,1),1);
      currmaxx=linematrix(parallellinematrix(myj,2),1);
      xorder=[parallellinematrix(myj,1) parallellinematrix(myj,2)];
    else
      currmaxx=linematrix(parallellinematrix(myj,1),1);
      currminx=linematrix(parallellinematrix(myj,2),1);
      xorder=[parallellinematrix(myj,2) parallellinematrix(myj,1)];
    end
    curravgmaxy=(linematrix(parallellinematrix(myj,1),4)+linematrix(parallellinematrix(myj,2),4))/2;
    curravgminy=(linematrix(parallellinematrix(myj,1),3)+linematrix(parallellinematrix(myj,2),3))/2;
    maxymetric=[-100 -2];
    minymetric=[-100 -2];
    for myi=1:size(horzmatrix,1)
      myminx=linematrix(horzmatrix(myi,2),1);
      mymaxx=linematrix(horzmatrix(myi,2),2);
      myy=horzmatrix(myi,1);
      minxerror=0;
      maxxerror=0;
      if (myminx > currminx)
        minxerror=notconnectmult*abs(myminx-currminx);
      end
      if (mymaxx < currmaxx)
        maxxerror=notconnectmult*abs(mymaxx-currmaxx);
      end
      currminymetric=0.5*(parallellinematrix(myj,3))-minxerror-maxxerror-(notconnectmult*abs(myy-curravgminy));
      currmaxymetric=0.5*(parallellinematrix(myj,3))-minxerror-maxxerror-(notconnectmult*abs(myy-curravgmaxy));
      if (currminymetric > minymetric(1))
        minymetric = [currminymetric horzmatrix(myi,2)];
      end
      if (currmaxymetric > maxymetric(1))
        maxymetric = [currmaxymetric horzmatrix(myi,2)];
      end
    end
    totalmetric=parallellinematrix(myj,3)+minymetric(1)+maxymetric(1);
    myk=1;
    if size(ordermatrix,1) > 0
      oldmetric = sum(ordermatrix(myk,5:7));
    end
    while (myk <= size(ordermatrix,1)) && (oldmetric > totalmetric)
      myk=myk+1;
      if (myk <= size(ordermatrix,1))
        oldmetric = sum(ordermatrix(myk,5:7));
      end
    end
    if (size(ordermatrix,1) > 0) && (myk <= size(ordermatrix,1))
      clear holdmatrix;
      holdmatrix = ordermatrix(1:myk-1,1:7);
      holdmatrix(myk,1:7) = [xorder minymetric(2) maxymetric(2) parallellinematrix(myj,3) minymetric(1) maxymetric(1)];
      holdmatrix(myk+1:size(ordermatrix,1)+1,1:7) = ordermatrix(myk:size(ordermatrix,1),1:7);
      ordermatrix = holdmatrix;
    else
      ordermatrix(size(ordermatrix,1)+1,1:7) = [xorder minymetric(2) maxymetric(2) parallellinematrix(myj,3) minymetric(1) maxymetric(1)];
    end
    myj=myj+1;
    currmetric=parallellinematrix(myj,3);
  end
  end
  outputmatrix=ordermatrix;  
end
