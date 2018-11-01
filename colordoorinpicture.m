% ee368 Spring 2010
% Line Database Functions
function [outputmatrix,doorsmatrix] = colordoorinpicture(linematrix,doorlinematrix,inputmatrix)

  % Function expects linematrix is a matrix of 6 columns with each row
  % [minimum x-value maximum x-value minimum y-value maximum y-value hough rho-value hough theta-value]
  %
  % Function expects doorlinematrix is a matrix of 7 columns with each row
  % sorted from maximum to minimum metric value
  % [left-vertical-line-number right-vertical-line-number lowest-horizontal-line-number highest-horizontal-line-number ...
  %  vertical-line-metric-score lowest-line-metric-score highest-line-metric-score]

  mywidth = size(inputmatrix,2);
  myheight = size(inputmatrix,1);

  outputmatrix=inputmatrix;

  doorsmatrix = [];
  doorcount = 1;
  doorrowcount = 1;
  for myi=1:size(doorlinematrix,1)
    mbmatrix=[];
% Calculate mx+b for all four lines
    for myj=1:4
 %    linematrix(myi,1:6)
      if doorlinematrix(myi,myj) ~= -2
        minx=linematrix(doorlinematrix(myi,myj),1);
        maxx=linematrix(doorlinematrix(myi,myj),2);
        miny=linematrix(doorlinematrix(myi,myj),3);
        maxy=linematrix(doorlinematrix(myi,myj),4);
        rho=linematrix(doorlinematrix(myi,myj),5);
        theta=linematrix(doorlinematrix(myi,myj),6);
      else
        if myj == 3
          minx=1;
          maxx=mywidth;
          miny=1;
          maxy=1;
          rho=1;
          theta=90;
        elseif myj == 4
          minx=1;
          maxx=mywidth;
          miny=myheight;
          maxy=myheight;
          rho=myheight;
          theta=90;
        else
          sprintf('ERROR: colordoorinpicture')
        end
      end
      if ((theta >=-90) & (theta < 0))
        otherangle=90+theta;
      elseif (theta > 0)
        otherangle=-90+theta;
      else
        otherangle=0;
      end
      m=tand(otherangle);
      b=sind(theta)*rho-1*tand(otherangle)*cosd(theta)*rho;
      if (myj == 3) || (myj == 4)
        mbmatrix(myj-2,1:4)=[m b theta doorlinematrix(myi,myj)];
      else
        flag=0;
        yes=1:myheight;
        if (myj == 1)
          if (m ~= 0)
            minxes=round((yes-b)./m);
          else
            minxes(1:myheight)=minx;
          end
        else
          if (m~=0)
            maxxes=round((yes-b)./m);
          else
            maxxes(1:myheight)=maxx;
          end
        end
%        mymat(1,1:length(yes))=yes;
%        mymat(2,1:length(yes))=xes
      end
    end

    for myj=1:2
      m=mbmatrix(myj,1);
      b=mbmatrix(myj,2);
      if (mbmatrix(myj,4) ~= -2)
        if (m >= 0)
          minx=minxes(round(linematrix(mbmatrix(myj,4),3)));
          maxx=maxxes(round(linematrix(mbmatrix(myj,4),4)));
        else
          minx=minxes(round(linematrix(mbmatrix(myj,4),4)));
          maxx=maxxes(round(linematrix(mbmatrix(myj,4),3)));
        end
      elseif (myj==1)
        minx=minxes(1);
        maxx=maxxes(1);
        m=0;
        b=1;
      elseif (myj==2)
        minx=minxes(myheight);
        maxx=maxxes(myheight);
        m=0;
        b=myheight;
      end
      xes=minx:maxx;
      if (myj == 1)
        minyes=round(m.*xes+b);
        if (m >= 0)
          for myk=min(minyes):max(minyes)
            if(myk <= 0)
              myk = 1;
            end
            index=find(minyes == myk,1,'last');
            doorsmatrix(doorrowcount,1:4)=[minxes(myk) xes(index) myk doorcount];
            doorrowcount = doorrowcount + 1;
          end
        else
          for myk=min(minyes):max(minyes)
            index=find(minyes == myk,1,'first');
            if(myk <= 0)
              myk = 1;
            end
            doorsmatrix(doorrowcount,1:4)=[xes(index) maxxes(myk) myk doorcount];
            doorrowcount = doorrowcount + 1;
          end
        end
      else
        maxyes=round(m.*xes+b);
        if (m < 0)
          for myk=min(maxyes):max(maxyes)
            index=find(maxyes == myk,1,'last');
            if(myk > myheight)
              myk = myheight;
            end
            doorsmatrix(doorrowcount,1:4)=[minxes(myk) xes(index) myk doorcount];
            doorrowcount = doorrowcount + 1;
          end
        else
          for myk=min(maxyes):max(maxyes)
            index=find(maxyes == myk,1,'first');
            if(myk > myheight)
              myk = myheight;
            end
            doorsmatrix(doorrowcount,1:4)=[xes(index) maxxes(myk) myk doorcount];
            doorrowcount = doorrowcount + 1;
          end
        end
      end
    end
    
    for myj=max(minyes)+1:min(maxyes)-1
      doorsmatrix(doorrowcount,1:4)=[minxes(myj) maxxes(myj) myj doorcount];
      doorrowcount = doorrowcount + 1;        
    end
    
    doorcount = doorcount + 1;
  end
    
  doorsmatrix;
  
  for myi=1:size(doorsmatrix,1)
    minx=doorsmatrix(myi,1);
    maxx=doorsmatrix(myi,2);
    curry=doorsmatrix(myi,3);
    if (minx < 1)
      minx=1;
    end
    if (maxx > mywidth)
      maxx=mywidth;
    end
    for myj=minx:maxx;
      outputmatrix(curry,myj) = 255;
    end
  end
end
