% ee368 Spring 2010
% run certain pictures or all pictures

for i=1:4
  if (i == 1)
   F = dir('.\door pictures\*.b*');
  elseif (i == 2)
   F = dir('.\door pictures\*.g*');
  elseif (i == 3)
    F = dir('.\door pictures\*.j*');
  else
    F = dir('.\door pictures\I*.j*');
  end
  
  %For each JPEG file in DoorImages Directory
  for fi = 1:length(F)

    [I, Q_mask, I_marked] = roi_preprocess(strcat('.\door pictures\',F(fi).name));
    figure(50);
    imshow(I);
    figure(51);
    imshow(Q_mask);
    figure(52);
    imshow(I_marked);
    
    %modificar o usuário aqui de acordo com onde foi mexer!!
    imwrite(I_marked,strcat('C:\Users\Italo\Documents\GitHub\PDI-TrabalhoFinal\Output\result_',F(fi).name)); 
    print(F(fi).name);
  end

end