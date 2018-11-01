function [I] = DrawQuad(I,Quad)

I = AddLineP(I,Quad.UR,Quad.UL);
I = AddLineP(I,Quad.UL,Quad.LL);
I = AddLineP(I,Quad.LL,Quad.LR);
I = AddLineP(I,Quad.LR,Quad.UR);

end