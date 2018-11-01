% ee368 Spring 2010
% hw5 - problem 2
function [door_cnt] = door_detection_wcrop(inputpixname)

  figcount = 1;
  try
    holdmatrix=im2double(imread(inputpixname,'JPEG'));
  catch exception
    try holdmatrix=im2double(imread(inputpixname,'GIF'));
    catch exception
      try holdmatrix=im2double(imread(inputpixname,'BMP'));
      catch exception
      end
    end
  end
  
    %Trim edges off the image
    I = holdmatrix;
    [R C b] = size(I);
    I = I(10:(R-10),10:(C-10),:);
    I = imresize(I,[R C]*1);
    [R C b] = size(I);
  
    crnr = [ 0 1 0;
             1 1 1;
             0 1 0];
    
    %Perform prelim line detection
    I_g = rgb2gray(I);
    I_e = edge(I_g,'canny',0.1);
    I_ef = imfilter(I_e,crnr,'corr');
    
    %Crop part of the image
    [I,I_ef,M] = LinesCrop(holdmatrix,I_ef);
    figure(13),imshow(holdmatrix);
    holdmatrix = I;
    figure(12),imshow(I);
%     
  picmatrix=holdmatrix;
  mywidth = size(picmatrix,2);
  myheight = size(picmatrix,1);

  [linematrix, blobmatrix, blobcount, hingematrix, figcount]=createlinedatabase(picmatrix,inputpixname);
  
  picmatrix7=drawlinedatabase(linematrix,myheight,mywidth);

  
  parallelmatrix=returnparallellinesindatabase(linematrix);
  notconnectmult=10;
  doorlinematrix=finddoorendsindatabase(linematrix,parallelmatrix,notconnectmult)
  finaldoorlinematrix=removelowprioritydoorsindatabase(doorlinematrix)
  while (size(finaldoorlinematrix,1) == 0) && (notconnectmult >= 2) && (size(doorlinematrix,1) > 0)
    notconnectmult = notconnectmult - 1
    doorlinematrix=finddoorendsindatabase(linematrix,parallelmatrix,notconnectmult)
    finaldoorlinematrix=removelowprioritydoorsindatabase(doorlinematrix)
  end
  if (size(finaldoorlinematrix,1) == 0) && (size(doorlinematrix,1) > 0)
    sprintf('Needed Blob Detection')
    doorlinematrix=improvemetricfromblobs(linematrix,blobmatrix,blobcount,hingematrix,doorlinematrix)
    finaldoorlinematrix=removelowprioritydoorsindatabase(doorlinematrix)
  end
  [regionrowvec regioncolumnvec] = find((picmatrix(:,:,1) > 220) & (picmatrix(:,:,2) > 220) & (picmatrix(:,:,3) > 220));
  for myj = 1:length(regionrowvec)
    picmatrix(regionrowvec(myj),regioncolumnvec(myj),1) = 192;
    picmatrix(regionrowvec(myj),regioncolumnvec(myj),2) = 192;
    picmatrix(regionrowvec(myj),regioncolumnvec(myj),3) = 192;
  end

  picmatrix(:,:,3)=colordoorinpicture(linematrix,finaldoorlinematrix,picmatrix(:,:,3));
  
  door_cnt = size(finaldoorlinematrix,1);
  
  picmatrix20=round(picmatrix7.*0.25)+(blobmatrix.*255)+(hingematrix.*192);
  figure(figcount)
  figcount = figcount + 1;
  imshow(cast(picmatrix20,'uint8'))
  mystring=sprintf('blob and line matrix combined for %s',inputpixname);
  title(mystring)

  figure(figcount)
  figcount = figcount + 1;
  imshow(picmatrix)
  mystring=sprintf('colored door for %s',inputpixname);
  title(mystring)
  

end
