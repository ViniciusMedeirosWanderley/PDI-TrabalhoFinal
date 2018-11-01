function I = DrawQuads(I,Quads)

I = zeros(size(I));
for i = 1:length(Quads)
   
    I = DrawQuad(I,Quads(i));
    
end

imshow(I);

end