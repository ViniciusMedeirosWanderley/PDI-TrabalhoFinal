function [doorvals] = AdjustDoorVals(doorvals,Q,ImageScale)

p_ul = Q.UL;

if(~isempty(doorvals))
doorvals(:,1) = round(doorvals(:,1)./ImageScale)+p_ul(2);
doorvals(:,2) = round(doorvals(:,2)./ImageScale)+p_ul(2);
doorvals(:,3) = round(doorvals(:,3)./ImageScale)+p_ul(1);
end

end