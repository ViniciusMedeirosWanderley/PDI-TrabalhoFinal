function [rat] = QuadRatio(Q)

    dy1 = abs(Q.UL(1)-Q.LL(1));
    dy2 = abs(Q.UR(1)-Q.LR(1));
    dx1 = abs(Q.UL(2)-Q.UR(2));
    dx2 = abs(Q.LL(2)-Q.LR(2));
    
    dy = (dy1+dy2)/2;
    dx = (dx1+dx2)/2;
    
    rat = dy/dx;
    
    
    
    
end