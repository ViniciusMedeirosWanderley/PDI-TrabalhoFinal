close all; clear all;
files = dir('*.jpg');

for fi = 1:length(files)
I = im2double(imread(files(fi).name));


[R C b] = size(I);

if(b > 1)
    I_g = rgb2gray(I);
else
    I_g = I;
end

[I_v,I_h] = GetVHEdges(I_g);
[Is,M,I_,V,H] = LinesHV(I_h,I_v);


f=figure(1);
subplot(121),imshow(I);
subplot(122),imagesc(imdilate(I_,ones(5,5)));


saveas(f,strcat('output\',files(fi).name));



end

