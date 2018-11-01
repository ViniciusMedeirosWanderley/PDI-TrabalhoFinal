function [rat,rat_err,rect_measure,parr_measure,area] = QuadFactors(Q)
    
    %Compute vector magnitudes
    dUL_LL = sum((Q.UL - Q.LL).^2);
    dUR_LR = sum((Q.UR - Q.LR).^2);
    dUL_UR = sum((Q.UL - Q.UR).^2);
    dLL_LR = sum((Q.LL - Q.LR).^2);
    dUR_LL = sum((Q.UR - Q.LL).^2);
    dUL_LR = sum((Q.UL - Q.LR).^2);
    
    %Compute Quad Angles
    ang_UL = acosd((dUR_LL-dUL_UR-dUL_LL)/(-2*sqrt(dUL_UR)*sqrt(dUL_LL)));
    ang_UR = acosd((dUL_LR-dUL_UR-dUR_LR)/(-2*sqrt(dUL_UR)*sqrt(dUR_LR)));
    ang_LL = acosd((dUL_LR-dLL_LR-dUL_LL)/(-2*sqrt(dLL_LR)*sqrt(dUL_LL)));
    ang_LR = acosd((dUR_LL-dLL_LR-dUR_LR)/(-2*sqrt(dLL_LR)*sqrt(dUR_LR)));
    
    %Make-up an error measure
    rect_measure = (90-ang_UL).^2+(90-ang_UR).^2+(90-ang_LL).^2+(90-ang_LR).^2;
    parr_measure = ((180-ang_LL)-ang_LR).^2+((180-ang_UL)-ang_UR).^2;

    %Compute the approximate ratio
    dy = (sqrt(dUL_LL)+sqrt(dUR_LR))/2;
    dx = (sqrt(dUL_UR)+sqrt(dLL_LR))/2;    
    rat_err = (sqrt(dUL_LL)-sqrt(dUR_LR)).^2+(sqrt(dUL_UR)-sqrt(dLL_LR)).^2;
    rat = dy/dx;   
    
    %Compute app. area
    area = dy*dx;%1/2*sqrt(dUR_LL)*(sqrt(dUL_UR)+sqrt(dUR_LR))*cosd(ang_UR);
    
end