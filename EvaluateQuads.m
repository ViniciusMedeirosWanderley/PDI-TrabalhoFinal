function [Q,metric,Q_area,Q_met] = EvaluateQuads(Q,N_max)

ratio = zeros(size(Q,2),1);
ratio_error = zeros(size(Q,2),1);
rect_error = zeros(size(Q,2),1);
parr_error = zeros(size(Q,2),1);
area = zeros(size(Q,2),1);
for i = 1:size(Q,2)
   
    [ratio(i) ratio_error(i) rect_error(i) parr_error(i) area(i)] = QuadFactors(Q(i));
    %Standard US Door 80 in./36 in.
    %metric(i) = (ratio_error(i)+rect_error(i)+parr_error(i))*abs(80/36-ratio(i));
    metric(i) = (rect_error(i)+ratio_error(i)+abs(80/36-ratio(i)));
end

%Limit the number of doors to N_max
if(size(Q,2) > N_max)
    
        area_sort = sort(area,'descend');
        lim_area = area_sort(N_max);
        Q_area = Q(area >= lim_area);
      

else
    Q_area = Q;
end


if(size(Q,2) > N_max)
       
            metric_sort = sort(metric);
            lim = metric_sort(N_max);
            Q_met = Q(metric <= lim);    
else
    Q_met = Q;
end

Q = [Q_area Q_met];
% 
% i = 1;
% while(i <= size(Q,2))
%     j = 1;
%     while(j <= size(Q,2))
%         if(i ~= j)
%             if(min(Q(i).UL == Q(j).UL)&&min(Q(i).UR == Q(j).UR)&&min(Q(i).LL == Q(j).LL)&&min(Q(i).LR == Q(j).LR))
%                Q(j) = [];
%             else
%                 j = j+1;
%             end
%         else
%             j = j+1;
%         end
% 
%     end
%     i = i+1;
% end




end


% function [Q,metric] = EvaluateQuads(Q,N_max)
% 
% ratio = zeros(size(Q,2),1);
% ratio_error = zeros(size(Q,2),1);
% rect_error = zeros(size(Q,2),1);
% parr_error = zeros(size(Q,2),1);
% area = zeros(size(Q,2),1);
% for i = 1:size(Q,2)
%    
%     [ratio(i) ratio_error(i) rect_error(i) parr_error(i) area(i)] = QuadFactors(Q(i));
%     %Standard US Door 80 in./36 in.
%     %metric(i) = (ratio_error(i)+rect_error(i)+parr_error(i))*abs(80/36-ratio(i));
%     metric(i) = (rect_error(i)+abs(80/36-ratio(i)))/area(i);
% end
% 
% %Limit the number of doors to N_max
% if(size(Q,2) > N_max)
%     
%     metric_sort = sort(metric);
%     lim = metric_sort(N_max);
%     Q = Q(metric <= lim);
%     area = area(metric <= lim);
%     
%     if(size(Q,2) > N_max)
%        
%         area_sort = sort(area,'descend');
%         lim_area = area_sort(N_max);
%         Q = Q(area >= lim_area);
%         
%     end
% 
% end
% 
% 
% 
% 
% 
% end