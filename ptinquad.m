function [in] = ptinquad(Q,pt)
% 
%     ulr = pt(1) >= Q.UL(1);
%     urr = pt(1) >= Q.UR(1);
%     llr = pt(1) <= Q.LL(1);
%     lrr = pt(1) <= Q.LR(1);
%     
%     ulc = pt(2) >= Q.UL(2);
%     urc = pt(2) <= Q.UR(2);
%     llc = pt(2) >= Q.LL(2);
%     lrc = pt(2) <= Q.LR(2);
%     
%     ulur = GetLineSide(fliplr(Q.UR),fliplr(pt),fliplr(Q.UL));
%     lllr = GetLineSide(fliplr(Q.LR),fliplr(pt),fliplr(Q.LL));
%     llul = GetLineSide(fliplr(Q.UL),fliplr(pt),fliplr(Q.LL));
%     lrur = GetLineSide(fliplr(Q.UR),fliplr(pt),fliplr(Q.LR));
%     
%     
%     in = ulr&urr&llr&lrr&ulc&urc&llc&lrc;
%     in = (ulur < 0)&& (lllr > 0);

[T1,T2] = GetTriangles(Q);
t1in = ptintri(T1,pt);
t2in = ptintri(T2,pt);

in = t1in || t2in;

end