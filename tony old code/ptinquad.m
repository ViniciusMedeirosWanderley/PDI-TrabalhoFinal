function [in] = ptinquad(Q,pt)

    ulr = pt(1) >= Q.UL(1);
    urr = pt(1) >= Q.UR(1);
    llr = pt(1) <= Q.LL(1);
    lrr = pt(1) <= Q.LR(1);
    
    ulc = pt(2) >= Q.UL(2);
    urc = pt(2) <= Q.UR(2);
    llc = pt(2) >= Q.LL(2);
    lrc = pt(2) <= Q.LR(2);
    
    in = ulr&urr&llr&lrr&ulc&urc&llc&lrc;

end