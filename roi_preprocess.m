% ee368 Spring 2010
% Region of Interest preprocessing
function [outI, Q_mask, I_marked] = roi_preprocess(inputpixname)
close all;

  inputpixname=inputpixname
  figcount = 1;
  try Inimage=im2double(imread(inputpixname,'JPEG'));
  catch exception
    try Inimage=im2double(imread(inputpixname,'GIF'));
    catch exception
      try Inimage=im2double(imread(inputpixname,'BMP'));
      catch exception
        outI=[];
        Q_mask=[];
        I_marked=[];
        return
      end
    end
  end

% crnr = [0 0 0 0 0 0 0;
%         0 0 1 1 1 1 1;
%         0 0 1 0 0 0 0;
%         0 0 1 0 0 0 0;
%         0 0 1 0 0 0 0;
%         0 0 1 0 0 0 0];
%     
% crnr = [ 1 1 1;
%          1 0 0;
%          1 0 0];

outI=Inimage;
%Subsample the image
%Improves corner detection because I'm summing horz./vert. lines
%50% is arbitrary
[R C b] = size(Inimage)
Inimage = Inimage(10:(R-10),10:(C-10),:);
%I = imresize(I,[R C]*0.5);
[R C b] = size(Inimage);
AREA = R*C;

%Check if it's color
%Compute gray image
if(b > 1)
  I_g = rgb2gray(Inimage);
else
  I_g = Inimage;
end

%Cross for dilation
%Needed to improve corners in image
crnr = [0 1 0;
        1 1 1;
        0 1 0];

%Do a high threshold canny detection  
I_e = edge(I_g,'canny',0.05,1);
%I_ef = imerode(imdilate(I_e,ones(2,2)),[0 1;1 0]);
I_ef = imdilate(I_e,crnr);

%Save the active image
I_orig = Inimage;

%Could crop the image...doesn't seem to help
%[I,I_ef,M] = LinesCrop(I,I_ef);

%Find vert/horz line crossing - corners / Max 250 /Min 25
[CE2,I_crn] = CornerDetect(I_ef,500,200);
figure(43),imagesc(I_crn);

%Show corners
CPD = imdilate(CE2,ones(5,5));
Inimage(:,:,1) = Inimage(:,:,1) .* ~CPD;
if(b > 1)
  Inimage(:,:,2) = Inimage(:,:,2) .* ~CPD;
  Inimage(:,:,3) = Inimage(:,:,3) .* ~CPD;
end
Inimage(:,:,1) = Inimage(:,:,1) + CPD;
if(b > 1)
  Inimage(:,:,2) = Inimage(:,:,2) + CPD;
end
figure(42),imshow(Inimage);
%Get the corner points
[r_,c_] = find(CE2 == 1);
pts = [r_,c_];

%Get quadrilaterals (not rectangles) meeting the criteria
%7 degrees,Min Height/Width 1.5, Max Height/Width 3.2
[Mask,Quads] = GetQuadMask(Inimage,pts,10,0,1,4);

Q_mask = zeros(size(I_ef));

q_cnt = 1;

CONN = zeros(length(Quads),1);
%If any rectangle was found...may need to change this
if(~isempty(Quads(1).UL))

Quads_o = Quads;

%Picks the 10 best quads
%Quads = EvaluateQuads(Quads,10);

%Picks the 10 best quads
[Quads,met,Q_area,Q_met] = EvaluateQuads(Quads,8);

%Evaluates how connected the quad is in the image
%Removed for now...biased to small quads
i = 1;
while( i <= size(Q_met,2))
   CONN(i) = GetQuadConnectivity(I_e,Q_met(i)); 
   if(CONN(i) < 0.2)
       Q_met(i) = [];
   else
       i = i + 1;
   end

end

Q_area = MergeQuads(Q_area);
Quads = [Q_area Q_met];




%Evaluates how connected the quad is in the image
%Removed for now...biased to small quads
for i = 1:length(Quads)
   % CONN(i) = GetQuadConnectivity(I_e,Quads(i)); 
end

%Merge quads into one or more larger quads
%May be a small bug...haven't found it yet
%Shutting this off may improve results but will make things take a lot
%longer
[c_max,i] = max(CONN);
Quads_om = Quads;
Quads = MergeQuads(Quads);

%Add the entire image into the detection stream
Q_im = struct('UL',[],'UR',[],'LL',[],'LR',[]);
Q_im.UL = [1 1];
Q_im.LL = [R 1];
Q_im.UR = [1 C];
Q_im.LR = [R C];

if(~isempty(Quads))
    Quads(size(Quads,2)+1) = Q_im;
else
    Quads(1) = Q_im;
end
%Clear previous variables
clear door_vals_mat;
clear door_cnts;

numberofquads=length(Quads)
%Foreach quad
i = 1;
flag=0;
while (i <= length(Quads)-1) || ((flag == 0) && (i == length(Quads)))
   % if(CONN(i) >= 0.2*c_max)
   %Draw the quad
    Q_mask = DrawQuad(Q_mask,Quad2Rect(Quads(i)));
   % end
   
   %Get the subimage
   [ROI,Q_r] = GetQuadImage(I_orig,Quads(i),30);   
   [R C b] = size(ROI);
    
   %If the quad is at least 50*50
   if(R*C > (50*50))
       if(R*C < (200*200))
           %If it's too small resize
           scale = 3;
           [ROI] = imresize(ROI,[R C]*scale);
       else
           scale = 1;
       end
       %Run door detector on the ROI
       try
       [door_cnt,door_image,door_vals,figcount] = door_detection_roi(ROI,inputpixname,(i == length(Quads)+1),figcount);
              %Correct door pixels to original image coordinates
       door_vals = AdjustDoorVals(door_vals,Q_r,scale);
       catch
           door_cnt = 0;
           door_vals = [];
       end;
       

   else
       door_cnt = 0;
       door_vals = 0;
   end
   if (door_cnt > 0)
     flag = 1;
   end
   door_cnts(i) = door_cnt;
   door_vals_mat(i) = {door_vals};
   i = i + 1;
end

else
  door_cnts=[];
end

%Mark the door
I_marked = I_orig;
indexes=(find(door_cnts > 0));
%for i = 1:length(door_cnts)   
%    if(door_cnts(i) >= 1)
if (length(indexes) > 0)
  for i = indexes'
    if (i == length(Quads))
      disp(sprintf('Full Image Found %d door(s).',door_cnts(i)));
    else
      disp(sprintf('Quad %d Found %d door(s).',i,door_cnts(i)));
    end
    door_vals = door_vals_mat(i);
    door_vals = door_vals{1};
    for r = 1:size(door_vals,1)
      door_row = door_vals(r,:);
      I_marked(door_row(3),door_row(1):door_row(2),3) = 1;
    end
  end
else
  disp('Whole Program Found 0 doors.');
end


end

