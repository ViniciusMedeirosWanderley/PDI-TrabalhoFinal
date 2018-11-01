function [I_o] = RemoveSmallRegions(I,SZ)

    LBL = bwlabeln(I);
    
    LBLs = unique(LBL(:));
    
    N = hist(LBL(:),length(LBLs));
    N(1) = 0;
    N(N < SZ) = 0;
    
    N_ACCEPT = find(N>0)-1;
    
    I_o = zeros(size(I));
    [R C] = size(I_o);
    for r = 1:R
        for c = 1:C
            if(~isempty(find(N_ACCEPT == LBL(r,c))))
                    I_o(r,c) = 1;
            end 
        end
    end

end