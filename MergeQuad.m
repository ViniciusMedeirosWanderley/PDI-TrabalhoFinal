function [Q] = MergeQuad(Q)
    if(~isempty(Q))
        Q_p = Q(1);
        i = 2;
        while (i <= size(Q,2))
            ul = ptinquad(Q_p,Q(i).UL);
            ur = ptinquad(Q_p,Q(i).UR);
            ll = ptinquad(Q_p,Q(i).LL);
            lr = ptinquad(Q_p,Q(i).LR);
                        
            switch_val = ul*8+ur*4+ll*2+lr;
            switch switch_val
                case 15 %All
                    Q(i) = [];
                    break;
                case 14 %UL,UR,LL
                    %Q_p.UR = MergePointUR(Q_p.UR,Q(i).UR);
                    Q_p.LR = MergePointLR(Q_p.LR,Q(i).LR);
                    %Q_p.UL = MergePointUL(Q_p.UL,Q(i).UL);
                    %Q_p.LL = MergePointLL(Q_p.LL,Q(i).LL);  
                    Q(i) = [];
                case 13 %UL,UR,LR
                    %Q_p.UR = MergePointUR(Q_p.UR,Q(i).UR);
                    %Q_p.LR = MergePointLR(Q_p.LR,Q(i).LR);
                    %Q_p.UL = MergePointUL(Q_p.UL,Q(i).UL);
                    Q_p.LL = MergePointLL(Q_p.LL,Q(i).LL);                    
                    Q(i) = [];
                case 12 %UL,UR
                    %Q_p.UR = MergePointUR(Q_p.UR,Q(i).UR);
                    Q_p.LR = MergePointLR(Q_p.LR,Q(i).LR);
                    %Q_p.UL = MergePointUL(Q_p.UL,Q(i).UL);
                    Q_p.LL = MergePointLL(Q_p.LL,Q(i).LL);                  
                    Q(i) = [];
                case 11 %UL,LL,LR
                    Q_p.UR = MergePointUR(Q_p.UR,Q(i).UR);
                    %Q_p.LR = MergePointLR(Q_p.LR,Q(i).LR);
                    %Q_p.UL = MergePointUL(Q_p.UL,Q(i).UL);
                    %Q_p.LL = MergePointLL(Q_p.LL,Q(i).LL);                    
                    Q(i) = [];
                case 10 %UL,LL; 
                    Q_p.UR = MergePointUR(Q_p.UR,Q(i).UR);
                    Q_p.LR = MergePointLR(Q_p.LR,Q(i).LR);
                    %Q_p.UL = MergePointUL(Q_p.UL,Q(i).UL);
                    %Q_p.LL = MergePointLL(Q_p.LL,Q(i).LL);                    
                    Q(i) = [];
                case 9  %UL,LR
                    Q_p.UR = MergePointUR(Q_p.UR,Q(i).UR);
                    %Q_p.LR = MergePointLR(Q_p.LR,Q(i).LR);
                    %Q_p.UL = MergePointUL(Q_p.UL,Q(i).UL);
                    Q_p.LL = MergePointLL(Q_p.LL,Q(i).LL);                    
                    Q(i) = [];
                case 8  %UL
                    Q_p.UR = MergePointUR(Q_p.UR,Q(i).UR);
                    Q_p.LR = MergePointLR(Q_p.LR,Q(i).LR);
                    %Q_p.UL = MergePointUL(Q_p.UL,Q(i).UL);
                    Q_p.LL = MergePointLL(Q_p.LL,Q(i).LL);                  
                    Q(i) = [];
                case 7  %UR,LL,LR
                    %Q_p.UR = MergePointUR(Q_p.UR,Q(i).UR);
                    %Q_p.LR = MergePointLR(Q_p.LR,Q(i).LR);
                    Q_p.UL = MergePointUL(Q_p.UL,Q(i).UL);
                    %Q_p.LL = MergePointLL(Q_p.LL,Q(i).LL);                    
                    Q(i) = [];
                case 6  %UR,LL
                    %Q_p.UR = MergePointUR(Q_p.UR,Q(i).UR);
                    Q_p.LR = MergePointLR(Q_p.LR,Q(i).LR);
                    Q_p.UL = MergePointUL(Q_p.UL,Q(i).UL);
                    %Q_p.LL = MergePointLL(Q_p.LL,Q(i).LL);               
                    Q(i) = [];
                case 5  %UR,LR
                    %Q_p.UR = MergePointUR(Q_p.UR,Q(i).UR);
                    %Q_p.LR = MergePointLR(Q_p.LR,Q(i).LR);
                    Q_p.UL = MergePointUL(Q_p.UL,Q(i).UL);
                    Q_p.LL = MergePointLL(Q_p.LL,Q(i).LL);                    
                    Q(i) = [];
                case 4  %UR
                    %Q_p.UR = MergePointUR(Q_p.UR,Q(i).UR);
                    Q_p.LR = MergePointLR(Q_p.LR,Q(i).LR);
                    Q_p.UL = MergePointUL(Q_p.UL,Q(i).UL);
                    Q_p.LL = MergePointLL(Q_p.LL,Q(i).LL);                   
                    Q(i) = [];
                case 3  %LL,LR
                    Q_p.UR = MergePointUR(Q_p.UR,Q(i).UR);
                    %Q_p.LR = MergePointLR(Q_p.LR,Q(i).LR);
                    Q_p.UL = MergePointUL(Q_p.UL,Q(i).UL);
                    %Q_p.LL = MergePointLL(Q_p.LL,Q(i).LL);                    
                    Q(i) = [];
                case 2  %LL
                    Q_p.UR = MergePointUR(Q_p.UR,Q(i).UR);
                    Q_p.LR = MergePointLR(Q_p.LR,Q(i).LR);
                    Q_p.UL = MergePointUL(Q_p.UL,Q(i).UL);
                    %Q_p.LL = MergePointLL(Q_p.LL,Q(i).LL);                 
                    Q(i) = [];
                case 1  %LR
                    Q_p.UR = MergePointUR(Q_p.UR,Q(i).UR);
                    %Q_p.LR = MergePointLR(Q_p.LR,Q(i).LR);
                    Q_p.UL = MergePointUL(Q_p.UL,Q(i).UL);
                    Q_p.LL = MergePointLL(Q_p.LL,Q(i).LL);                  
                    Q(i) = [];
                case 0  %NONE
                    if(Q_p.UR == Q(i).UL)
                        ul = 1;
                    else
                        ul = 0;
                    end
                    if(Q_p.UL == Q(i).UR)
                        ur = 1;
                    else
                        ur = 0;
                    end
                    if(Q_p.LL == Q(i).LR)
                        lr = 1;
                    else
                        lr = 0;
                    end
                    if(Q_p.LR == Q(i).LL)
                        ll = 1;
                    else
                        ll = 0;
                    end
                      switch_val2 = ul*8+ur*4+ll*2+lr;
                        switch switch_val2
                            case 15 %All
                                Q(i) = [];
                                break;
                            case 14 %UL,UR,LL
                                Q_p.LL = Q(i).LR;
                                Q(i) = [];
                            case 13 %UL,UR,LR
                                Q_p.LL = Q(i).LL;
                                Q(i) = [];
                            case 12 %UL,UR
                                Q_p.LR = Q(i).LR;
                                Q_p.LL = Q(i).LL;
                                Q(i) = [];
                            case 11 %UL,LL,LR
                                Q_p.UR = Q(i).UR;
                                Q(i) = [];
                            case 10 %UL,LL; 
                                Q_p.UR = Q(i).UR;
                                Q_p.LR = Q(i).LR;
                                Q(i) = [];
                            case 9  %UL,LR
                                Q_p.UR = Q(i).UR;
                                Q_p.LL = Q(i).LL;                    
                                Q(i) = [];
                            case 8  %UL
                                Q_p.UR = Q(i).UR;
                                Q_p.LR = Q(i).LR;
                                Q_p.LL = Q(i).LL;     
                                Q(i) = [];
                            case 7  %UR,LL,LR                      
                                Q_p.UL = Q(i).UL;              
                                Q(i) = [];
                            case 6  %UR,LL
                                Q_p.LR = Q(i).LR;
                                Q_p.UL = Q(i).UL;            
                                Q(i) = [];
                            case 5  %UR,LR
                                Q_p.UL = Q(i).UL;
                                Q_p.LL = Q(i).LL;       
                                Q(i) = [];
                            case 4  %UR
                                Q_p.LR = Q(i).LR;
                                Q_p.UL = Q(i).UL;
                                Q_p.LL = Q(i).LL;      
                                Q(i) = [];
                            case 3  %LL,LR
                                Q_p.UR = Q(i).UR;
                                Q_p.UL = Q(i).UL;                
                                Q(i) = [];
                            case 2  %LL
                                Q_p.UR = Q(i).UR;
                                Q_p.LR = Q(i).LR;
                                Q_p.UL = Q(i).UL;           
                                Q(i) = [];
                            case 1  %LR
                                Q_p.UR = Q(i).UR;
                                Q_p.UL = Q(i).UL;
                                Q_p.LL = Q(i).LL;     
                                Q(i) = [];
                            case 0  %NONE
                                i = i + 1;                                
                        end
            end
                
            
        end
    end
    Q(1) = Q_p;
end