function [T1,T2] = GetTriangles(Q)

    T1 = struct('A',Q.UL,'B',Q.LL,'C',Q.LR);
    T2 = struct('A',Q.UL,'B',Q.UR,'C',Q.LR);

end