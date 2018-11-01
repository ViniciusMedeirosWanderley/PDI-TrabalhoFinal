function [pt] = MergePointUL(pt1,pt2)
        pt(1) = min(pt1(1),pt2(1));        
        pt(2) = min(pt1(2),pt2(2));
end