% ee368 Spring 2010
% Create the line database
function [linematrix,blobmatrix,blobcount,hingematrix,figcount] = createlinedatabase(inputmatrix,inputpixname)

  figcount = 1;
  mywidth = size(inputmatrix,2);
  myheight = size(inputmatrix,1);
  size(inputmatrix)

  picmatrix14=zeros(myheight,mywidth);
  picmatrix12=zeros(myheight,mywidth);

  picmatrix2 = inputmatrix;
  I_o = rgb2gray(picmatrix2);
  I_e = edge(I_o,'canny',0.02);
  
  picmatrix3 = cast(I_e,'uint8').*255;
  linematrix=[];
  linematrix2=[];

%   figure(figcount)
%   figcount = figcount + 1;
%   imshow(cast(picmatrix3,'uint8'))
%   mystring=sprintf('tony out for %s',inputpixname);
%   title(mystring)

%  [picmatrix4,sobthresh,sobv,sobh]=edge(picmatrix3,'sobel','nothinning');

%  picmatrix4=abs(sobv).*(255/max(max(abs(sobv))));
%  picmatrix4=im2bw(picmatrix4).*255;
  picmatrix4=picmatrix3;
  picmatrix4=imerode(cast(picmatrix4,'uint8'),strel('line',3,0));
  picmatrix4=imdilate(cast(picmatrix4,'uint8'),strel('line',7,0));
%   figure(figcount)
%   figcount = figcount + 1;
%   imshow(cast(picmatrix4,'uint8'))
%   mystring=sprintf('sobel v for %s',inputpixname);
%   title(mystring)

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
%   figure(figcount)
%   figcount = figcount + 1;
%   imshow(cast(picmatrix4,'uint8'))
%   mystring=sprintf('sobel h for %s',inputpixname);
%   title(mystring)
%   
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

  blobcount=[0];
  blobmatrix=picmatrix12;
  hingematrix=picmatrix14;

end
