% ee368 Spring 2010
% run certain pictures or all pictures

close all; clear all;
for i=1:4
  if (i == 1)
    files = dir('b.jpg');
  elseif (i == 2)
    files = dir('j.jpg');
  elseif (i == 3)
    files = dir('.\door pictures\*.j*');
  else
    files = dir('.\door pictures\I*.j*');
  end

  %For each JPEG file in DoorImages Directory
  for fi = 1:length(files)

    [I, Q_mask, I_marked] = roi_preprocess(strcat('.\door pictures\',files(fi).name));
    figure(50);
    imshow(I);
    figure(51);
    imshow(Q_mask);
    figure(52);
    imshow(I_marked);

%    saveas(f,strcat('output\output_',files(fi).name));
    myoutfilename=strcat('Output/output_',files(fi).name)
    print('-djpeg','-f52',myoutfilename)
  end


end

