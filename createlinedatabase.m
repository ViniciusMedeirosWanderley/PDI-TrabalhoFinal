% ee368 Spring 2010
% Create the line database
function [linematrix,blobmatrix,blobcount,hingematrix,figcount] = ...
         createlinedatabase(inputmatrix,inputpixname,mode,figcount)

% Mode = 0 means do blob detection stuff
% Mode = 1 means shut off blob detection

  CurrMode=mode
  mywidth = size(inputmatrix,2);
  myheight = size(inputmatrix,1);
  colordepth = size(inputmatrix,3);
  size(inputmatrix)

  picmatrix14=zeros(myheight,mywidth);
  picmatrix12=zeros(myheight,mywidth);

  picmatrix2 = inputmatrix;
  
  if (colordepth > 1)
    I_o = rgb2gray(picmatrix2);
  else
    I_o = picmatrix2;
  end
  I_e = edge(I_o,'canny',0.02);
  
  picmatrix3 = cast(I_e,'uint8').*255;
  linematrix=[];
  linematrix2=[];

  figure(figcount)
  figcount = figcount + 1;
  imshow(cast(picmatrix3,'uint8'))
  mystring=sprintf('tony out for %s',inputpixname);
  title(mystring)

%  [picmatrix4,sobthresh,sobv,sobh]=edge(picmatrix3,'sobel','nothinning');

%  picmatrix4=abs(sobv).*(255/max(max(abs(sobv))));
%  picmatrix4=im2bw(picmatrix4).*255;
  picmatrix4=picmatrix3;
  picmatrix4=imerode(cast(picmatrix4,'uint8'),strel('line',3,0));
  picmatrix4=imdilate(cast(picmatrix4,'uint8'),strel('line',7,0));
  figure(figcount)
  figcount = figcount + 1;
  imshow(cast(picmatrix4,'uint8'))
  mystring=sprintf('sobel v for %s',inputpixname);
  title(mystring,'interpreter', 'none')

  [picmatrix5,countvector] = regioncount(picmatrix4);
%  regionstodelete = find((0 < countvector) & (countvector < 200))
%  for myi = 1:length(regionstodelete)
%    for myj = 1:countvector(regionstodelete(myi))
%      picmatrix5(regionrowmatrix(regionstodelete(myi),myj),regioncolumnmatrix(regionstodelete(myi),myj)) = 0;
%    end
%  end
  regionstotest = find(countvector > 50);
  picmatrix8=zeros(myheight,mywidth);
  for myi = 1:length(regionstotest)
    picmatrix6=zeros(myheight,mywidth);
    [regionrowmatrix,regioncolumnmatrix]=find(picmatrix5 == regionstotest(myi));
    for myj = 1:length(regionrowmatrix)
      picmatrix6(regionrowmatrix(myj),regioncolumnmatrix(myj)) = 1;
    end
%    for myj = 1:countvector(regionstotest(myi))
%      picmatrix6(regionrowmatrix(regionstotest(myi),myj),regioncolumnmatrix(regionstotest(myi),myj)) = 1;
%    end
%  figure(figcount)
%  figcount = figcount + 1;
%  imshow(cast(picmatrix6.*255,'uint8'))
%  mystring=sprintf('Region deleted image for %s',inputpixname);
%  title(mystring)
    [Hmatrix,mytheta,myrho]=hough(picmatrix6);
    currHmax=max(max(Hmatrix));
    countvector(regionstotest(myi));
%    if currHmax > countvector(regionstotest(myi))/7
      [rhoindex,thetaindex]=find(Hmatrix == currHmax);
      maxrho=(sum(myrho(rhoindex))/length(rhoindex));
      maxtheta=sum(mytheta(thetaindex))/length(thetaindex);
      linematrix=addlinetolinedatabase([min(regioncolumnmatrix) max(regioncolumnmatrix) min(regionrowmatrix) max(regionrowmatrix) maxrho maxtheta],linematrix);
      linematrix2=addlinetolinedatabaseorig([min(regioncolumnmatrix) max(regioncolumnmatrix) min(regionrowmatrix) max(regionrowmatrix) maxrho maxtheta],linematrix2);
%    end
  end
  clear regioncolumnmatrix;
  clear regionrowmatrix;
  
%  picmatrix4=abs(sobh).*(255/max(max(abs(sobh))));
%  picmatrix4=im2bw(picmatrix4).*255;
  picmatrix4=picmatrix3;
  picmatrix4=imerode(cast(picmatrix4,'uint8'),strel('line',3,90));
  picmatrix4=imdilate(cast(picmatrix4,'uint8'),strel('line',7,90));

%  picmatrix10=drawlinedatabase(linematrix,myheight,mywidth);
  figure(figcount)
  figcount = figcount + 1;
  imshow(cast(picmatrix4,'uint8'))
  mystring=sprintf('sobel h for %s',inputpixname);
  title(mystring, 'interpreter', 'none')
  
  [picmatrix5,countvector] = regioncount(picmatrix4);
  regionstotest = find(countvector > 50);
  for myi = 1:length(regionstotest)
    picmatrix6=zeros(myheight,mywidth);
    [regionrowmatrix,regioncolumnmatrix]=find(picmatrix5 == regionstotest(myi));
    for myj = 1:length(regionrowmatrix)
      picmatrix6(regionrowmatrix(myj),regioncolumnmatrix(myj)) = 1;
    end
%    for myj = 1:countvector(regionstotest(myi))
%      picmatrix6(regionrowmatrix(regionstotest(myi),myj),regioncolumnmatrix(regionstotest(myi),myj)) = 1;
%    end
%  figure(figcount)
%  figcount = figcount + 1;
%  imshow(cast(picmatrix6.*255,'uint8'))
%  mystring=sprintf('Region deleted image for %s',inputpixname);
%  title(mystring)
%    [Hmatrix,mytheta,myrho]=hough(picmatrix6,'ThetaResolution',0.1,'RhoResolution',0.2);
    [Hmatrix,mytheta,myrho]=hough(picmatrix6);
    currHmax=max(max(Hmatrix));
    countvector(regionstotest(myi));
%    if currHmax > countvector(regionstotest(myi))/7
      [rhoindex,thetaindex]=find(Hmatrix == currHmax);
      maxrho=(sum(myrho(rhoindex))/length(rhoindex));
      maxtheta=sum(mytheta(thetaindex))/length(thetaindex);
      linematrix=addlinetolinedatabase([min(regioncolumnmatrix) max(regioncolumnmatrix) min(regionrowmatrix) max(regionrowmatrix) maxrho maxtheta],linematrix);
      linematrix2=addlinetolinedatabaseorig([min(regioncolumnmatrix) max(regioncolumnmatrix) min(regionrowmatrix) max(regionrowmatrix) maxrho maxtheta],linematrix2);
%    end
  end
  clear regioncolumnmatrix;
  clear regionrowmatrix;

  mypower=3;
  picmatrix14=zeros(myheight,mywidth);
  picmatrix12=zeros(myheight,mywidth);
  countvector=[];
  
  if (mode == 0)
    picmatrix3 = otsu(cast(I_o.*255,'uint8'),2^mypower);

    for mynumber=1:2^mypower-1
%  for mynumber=1:5
      threshhold = mynumber
      picmatrix10=picmatrix3-mynumber;
      [threshrow,threshcol]=find(picmatrix10 > 0);
      for myi=1:length(threshrow)
        picmatrix10(threshrow(myi),threshcol(myi)) = 255;
      end
      [threshrow,threshcol]=find(picmatrix10 < 0);
      for myi=1:length(threshrow)
        picmatrix10(threshrow(myi),threshcol(myi)) = 0;
      end

%      figure(figcount)
%      figcount = figcount + 1;
%      imshow(cast(picmatrix10,'uint8'))
%      mystring=sprintf('Otsu image at power %d for %s',mynumber,inputpixname);
%      title(mystring)
%      picmatrix10=picmatrix3;
      [picmatrix7,countvector] = regioncount(picmatrix10);
  
%      figure(figcount)
%      figcount = figcount + 1;
%      imshow(cast(picmatrix7.*255,'uint8'))
%      mystring=sprintf('Blob image positive at %d for %s',mynumber,inputpixname);
%      title(mystring)

      regionstodelete = find((countvector < 40) | (countvector > 500));
      for myi = regionstodelete'
        [regionrowvec regioncolumnvec]=find(picmatrix7==myi);
        for myj = 1:length(regionrowvec)
          picmatrix7(regionrowvec(myj),regioncolumnvec(myj)) = 0;
        end
      end
      picmatrix11=im2bw(picmatrix10,1);
      picmatrix11=(~picmatrix11).*255;
  
%      figure(figcount)
%      figcount = figcount + 1;
%      imshow(cast(picmatrix11.*255,'uint8'))
%      mystring=sprintf('Blob image negative at %d for %s',mynumber,inputpixname);
%      title(mystring)

      [picmatrix11,countvector] = regioncount(picmatrix11);
      regionstodelete = find((countvector < 40) | (countvector > 500));
      for myi = regionstodelete'
        [regionrowvec regioncolumnvec]=find(picmatrix11==myi);
        for myj = 1:length(regionrowvec)
          picmatrix11(regionrowvec(myj),regioncolumnvec(myj)) = 0;
        end
      end
      picmatrix12=((picmatrix7+picmatrix11)./2)+picmatrix12;
      picmatrix12=im2bw(picmatrix12.*255,1);
      [picmatrix13,countvector] = regioncount(picmatrix12.*255);
      regionstotest = find(countvector > 30);
      for myi = 1:length(regionstotest)
        picmatrix15=zeros(myheight,mywidth);
        [regionrowmatrix,regioncolumnmatrix]=find(picmatrix13 == regionstotest(myi));
        for myj = 1:length(regionrowmatrix)
          picmatrix15(regionrowmatrix(myj),regioncolumnmatrix(myj)) = 1;
        end
        [Hmatrix,mytheta,myrho]=hough(picmatrix15);
        currHmax=max(max(Hmatrix));
        countvector(regionstotest(myi));
        if currHmax > countvector(regionstotest(myi))/5
          [rhoindex,thetaindex]=find(Hmatrix == currHmax);
          maxtheta=sum(mytheta(thetaindex))/length(thetaindex);
          if (maxtheta > -45) & (maxtheta < 45) & ...
             ((max(regioncolumnmatrix)-min(regioncolumnmatrix)) < 7) & ...
             ((max(regionrowmatrix)-min(regionrowmatrix)) < 50)
            for myk=1:length(regionrowmatrix)
              picmatrix14(regionrowmatrix(myk),regioncolumnmatrix(myk))=1;
              picmatrix12(regionrowmatrix(myk),regioncolumnmatrix(myk))=0;
            end
          else
            for myk=1:length(regionrowmatrix)
              picmatrix12(regionrowmatrix(myk),regioncolumnmatrix(myk))=0;
            end
          end
        end
      end
    end
  
    picmatrix12=imerode(picmatrix12,strel('square',3));
    [picmatrix12,countvector] = regioncount(picmatrix12.*255);
%    figure(figcount)
%    figcount = figcount + 1;
%    imshow(cast(picmatrix7.*255,'uint8'))
%    mystring=sprintf('Blob image positive at %d for %s',mynumber,inputpixname);
%    title(mystring)

%    regionstodelete = find((countvector < 10) | (countvector > 400));
%    for myi = regionstodelete'
%      countvector(myi) = 0;
%      [regionrowvec regioncolumnvec]=find(picmatrix12==myi);
%      for myj = 1:length(regionrowvec)
%        picmatrix12(regionrowvec(myj),regioncolumnvec(myj)) = 0;
%      end
%    end

%    regionstotest = find((countvector >= 10) | (countvector <= 600));
%    for myi = regionstotest'
    
%    end
  
    [picmatrix14,countvector] = regioncount(picmatrix14);
%  figure(figcount)
%  figcount = figcount + 1;
%  imshow(cast(picmatrix7.*255,'uint8'))
%  mystring=sprintf('Blob image positive at %d for %s',mynumber,inputpixname);
%  title(mystring)
    regionstodelete = find(countvector > 100);
    for myi = regionstodelete'
      countvector(myi) = 0;
      [regionrowvec regioncolumnvec]=find(picmatrix14==myi);
      for myj = 1:length(regionrowvec)
        picmatrix14(regionrowvec(myj),regioncolumnvec(myj)) = 0;
      end
    end
  end
  blobmatrix=picmatrix12;
  blobcount=countvector;
  hingematrix=picmatrix14;
  hingematrix=im2bw(hingematrix,0.5);

end
