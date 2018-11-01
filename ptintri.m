function [in] = ptintri(T,pt)

l1 = T.A-T.B;
l2 = pt-T.B;
cp1 = det([(l1);(T.C-T.B)]);
pp1 = det([(l1);(l2)]);
dir1 = (sum(sign(l1) == sign(l2))==2)&&(sum(l2.^2) <= sum(l1.^2));

l1 = T.C-T.A;
l2 = pt-T.A;
cp2 = det([(l1);(T.B-T.A)]);
pp2 = det([(l1);(l2)]);
dir2 = (sum(sign(l1) == sign(l2))==2)&&(sum(l2.^2) <= sum(l1.^2));

l1 = T.B-T.C;
l2 = pt-T.C;
cp3 = det([(l1);(T.A-T.C)]);
pp3 = det([(l1);(l2)]);
dir3 = (sum(sign(l1) == sign(l2))==2)&&(sum(l2.^2) <= sum(l1.^2));

if(sign(pp1) == sign(cp1) && sign(cp2) == sign(pp2) && sign(cp3) == sign(pp3)...
    || pp1 == 0 && dir1 == 1 || pp2 == 0 && dir2 == 1 || pp3 == 0 && dir3 == 1)
    in = 1;
else
    in = 0;
end

end