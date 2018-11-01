function [CONN] = GetQuadConnectivity(I_e,Quad)
    
    %I_e_h = imdilate(I_e,ones(30,1));
    %I_e_v = imdilate(I_e,ones(1,30));
    
%    I_e = I_e_h+I_e_v;
    I_e(I_e > 0) = 1;
    
    LI_ULUR = GetLineIndices(I_e,Quad.UL,Quad.UR);    
    PTS_ULUR = I_e(LI_ULUR);
    CONN_ULUR = NumberLineRuns(PTS_ULUR);
    CONN_ULUR = sum(unique(CONN_ULUR))./length(PTS_ULUR);
    
    LI_URLR = GetLineIndices(I_e,Quad.UR,Quad.LR);
    PTS_URLR = I_e(LI_URLR);
    CONN_URLR = NumberLineRuns(PTS_URLR);
    CONN_URLR = sum(unique(CONN_URLR))./length(PTS_URLR);
    
    LI_LRLL = GetLineIndices(I_e,Quad.LR,Quad.LL);
    PTS_LRLL = I_e(LI_LRLL);
    CONN_LRLL = NumberLineRuns(PTS_LRLL);
    CONN_LRLL = sum(unique(CONN_LRLL))./length(PTS_LRLL);

    LI_LLUL = GetLineIndices(I_e,Quad.LL,Quad.UL);
    PTS_LLUL = I_e(LI_LLUL);
    CONN_LLUL = NumberLineRuns(PTS_LLUL);
    CONN_LLUL = sum(unique(CONN_LLUL))./length(PTS_LLUL);
    
    %CONN = (CONN_ULUR + 2*CONN_URLR + CONN_LRLL + 2*CONN_LLUL)./6;
    CONN = (CONN_ULUR*CONN_URLR*CONN_LRLL*CONN_LLUL);
    
%     plot(PTS_LLUL,'b');hold on;axis([0 length(PTS_LLUL) -1 2 ]);
%     plot(PTS_URLR,'r')
%     plot(PTS_LLUL,'g')
%     plot(PTS_LLUL,'y')


end