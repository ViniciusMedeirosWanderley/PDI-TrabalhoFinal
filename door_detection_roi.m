% ee368 Spring 2010
% project
function [door_cnt,picmatrix,doorsmatrix,figcount] = door_detection_roi(holdmatrix, inputpixname, mode, figcount)

% Mode = 0 means do blob detection stuff
% Mode = 1 means shut off blob detection

  picmatrix=holdmatrix;
  mywidth = size(picmatrix,2);
  myheight = size(picmatrix,1);

  [linematrix, blobmatrix, blobcount, hingematrix, figcount]=createlinedatabase(picmatrix,inputpixname,mode,figcount);
   
  parallelmatrix=returnparallellinesindatabase(linematrix);
  notconnectmult=10;
  doorlinematrix=finddoorendsindatabase(linematrix,parallelmatrix,notconnectmult)
  [doorlinematrix2,blobmatrix,blobcount]=improvemetricfromblobsnew(linematrix,blobmatrix,blobcount,hingematrix,doorlinematrix);
  finaldoorlinematrix=removelowprioritydoorsindatabase(linematrix,doorlinematrix2,myheight,mywidth)
  while (size(finaldoorlinematrix,1) == 0) && (notconnectmult >= 2) && (size(doorlinematrix,1) >= 0)
    notconnectmult = notconnectmult - 1
    doorlinematrix=finddoorendsindatabase(linematrix,parallelmatrix,notconnectmult)
    [doorlinematrix2,blobmatrix,blobcount]=improvemetricfromblobsnew(linematrix,blobmatrix,blobcount,hingematrix,doorlinematrix);
    finaldoorlinematrix=removelowprioritydoorsindatabase(linematrix,doorlinematrix2,myheight,mywidth)
  end
%  if (size(finaldoorlinematrix,1) == 0) && (size(doorlinematrix,1) > 0)
%    sprintf('Needed Blob Detection')
%    doorlinematrix=improvemetricfromblobs(linematrix,blobmatrix,blobcount,hingematrix,doorlinematrix)
%    finaldoorlinematrix=removelowprioritydoorsindatabase(doorlinematrix)
%  end
  picmatrix=picmatrix.*255;
  if (size(picmatrix,3) > 1)
    [regionrowvec regioncolumnvec] = find((picmatrix(:,:,1) > 220) & (picmatrix(:,:,2) > 220) & (picmatrix(:,:,3) > 220));
    for myj = 1:length(regionrowvec)
      picmatrix(regionrowvec(myj),regioncolumnvec(myj),1) = 192;
      picmatrix(regionrowvec(myj),regioncolumnvec(myj),2) = 192;
      picmatrix(regionrowvec(myj),regioncolumnvec(myj),3) = 192;
    end

    [picmatrix(:,:,3),doorsmatrix]=colordoorinpicture(linematrix,finaldoorlinematrix,picmatrix(:,:,3));
  else
    crudmatrix=zeros(myheight,mywidth);
    [picmatrix,doorsmatrix]=colordoorinpicture(linematrix,finaldoorlinematrix,picmatrix);
%    picmatrix=crudmatrix;
  end
  linematrix
  
  picmatrix7=drawlinedatabase(linematrix,myheight,mywidth);
  picmatrix20=round(picmatrix7.*0.25)+(blobmatrix.*255)+(hingematrix.*192);
  figure(figcount)
  figcount = figcount + 1;
  imshow(cast(picmatrix20,'uint8'))
  mystring=sprintf('blob and line matrix combined for %s',inputpixname);
  title(mystring)

  figure(figcount)
  figcount = figcount + 1;
  imshow(cast(picmatrix,'uint8'))
  mystring=sprintf('colored door for %s',inputpixname);
  title(mystring)
 
  door_cnt = size(finaldoorlinematrix,1);

end
