function [Q] = Quad2Rect(Q)

Q.UL(1) = min(Q.UL(1),Q.UR(1));%Minimum row
Q.UR(1) = Q.UL(1);%Same row
Q.UL(2) = min(Q.UL(2),Q.LL(2));%Minimum col
Q.LL(2) = Q.UL(2);%Same col
Q.LR(1) = max(Q.LR(1),Q.LL(1));%Maximum row
Q.LL(1) = Q.LR(1);%Same row
Q.LR(2) = max(Q.LR(2),Q.UR(2));%Maximum col
Q.UR(2) = Q.LR(2);%Same col

end
