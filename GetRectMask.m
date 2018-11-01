function [Mask,Quads] = GetQuadMask(I,pts,ang_lim,area_lim,ratl,ratu)

Quads = struct('UL',[],...
               'UR',[],...
               'LL',[],...
               'LR',[]);
q_cnt = 1;

ratio_liml = ratl;
ratio_limu = ratu;
[R C b] = size(I);
AREA = R*C;

Mask = zeros(size(I));


for p = 1:length(pts)
   
    p_c = pts-repmat(pts(p,:),[length(pts),1]);
    p_ang = atan2(-p_c(:,1),p_c(:,2))*180/pi;
    p_dist = sqrt(sum(p_c'.^2))';
    
    for q1 = 1:length(p_c)
        
        if(p_ang(q1) < (0+ang_lim) && p_ang(q1) > (0-ang_lim)) %Ang = 0/-90
           for q2 = 1:length(p_c)
              if(q2 ~= q1)
                  if(p_ang(q2) < (-90+ang_lim) && p_ang(q2) > (-90-ang_lim))   
                      dist_1 = p_dist(q1); %width
                      dist_2 = p_dist(q2); %height
                      ratio = dist_2./dist_1; %height/width
                      area = dist_2*dist_1;
                      area_ratio = area/AREA;
                      if(area_ratio > area_lim)
                      if((ratio > ratio_liml) && (ratio < ratio_limu))
                         Quads(q_cnt) = struct('UL',pts(p,:),'UR',pts(q1,:),'LL',pts(q2,:),'LR',[pts(q2,1),pts(q1,2)]);
                         q_cnt = q_cnt + 1;
%                          Mask = AddLine(Mask,pts(p,1),pts(p,2),pts(q2,1),pts(q2,2));
%                          Mask = AddLine(Mask,pts(p,1),pts(p,2),pts(q1,1),pts(q1,2));
%                          Mask = AddLine(Mask,pts(q1,1),pts(q1,2),pts(q2,1),pts(q1,2));
%                          Mask = AddLine(Mask,pts(q2,1),pts(q2,2),pts(q2,1),pts(q1,2));
                      end
                      end
                  end
              end
           end            
        end
        
                
        if((p_ang(q1) < (180+ang_lim) && p_ang(q1) > (180-ang_lim))||(p_ang(q1) < (-180+ang_lim) && p_ang(q1) > (-180-ang_lim))) %Ang = 180/-90
           for q2 = 1:length(p_c)
              if(q2 ~= q1)
                  if(p_ang(q2) < (-90+ang_lim) && p_ang(q2) > (-90-ang_lim))   
                      dist_1 = p_dist(q1); %width
                      dist_2 = p_dist(q2); %height
                      ratio = dist_2./dist_1; %height/width
                      
                      area = dist_2*dist_1;
                      area_ratio = area/AREA;
                      if(area_ratio > area_lim)
                      if((ratio > ratio_liml) && (ratio < ratio_limu))
                         Quads(q_cnt) = struct('UL',pts(q1,:),'UR',pts(p,:),'LL',[pts(q2,1),pts(q1,2)],'LR',pts(q2,:));
                         q_cnt = q_cnt + 1;
%                          Mask = AddLine(Mask,pts(p,1),pts(p,2),pts(q2,1),pts(q2,2));
%                          Mask = AddLine(Mask,pts(p,1),pts(p,2),pts(q1,1),pts(q1,2));
%                          Mask = AddLine(Mask,pts(q1,1),pts(q1,2),pts(q2,1),pts(q1,2));
%                          Mask = AddLine(Mask,pts(q2,1),pts(q2,2),pts(q2,1),pts(q1,2));
                      end
                      end
                  end
              end
           end            
        end
        
         if((p_ang(q1) < (180+ang_lim) && p_ang(q1) > (180-ang_lim))||(p_ang(q1) < (-180+ang_lim) && p_ang(q1) > (-180-ang_lim)))%180/90
           for q2 = 1:length(p_c)
              if(q2 ~= q1)
                  if(p_ang(q2) < (90+ang_lim) && p_ang(q2) > (90-ang_lim))   
                      dist_1 = p_dist(q1); %width
                      dist_2 = p_dist(q2); %height
                      ratio = dist_2./dist_1; %height/width
                      
                      area = dist_2*dist_1;
                      area_ratio = area/AREA;
                      if(area_ratio > area_lim)
                      if((ratio > ratio_liml) && (ratio < ratio_limu))
                         Quads(q_cnt) = struct('UL',[pts(q2,1),pts(q1,2)],'UR',pts(q2,:),'LL',pts(q1,:),'LR',pts(p,:));
                         q_cnt = q_cnt + 1;
%                          Mask = AddLine(Mask,pts(p,1),pts(p,2),pts(q2,1),pts(q2,2));
%                          Mask = AddLine(Mask,pts(p,1),pts(p,2),pts(q1,1),pts(q1,2));
%                          Mask = AddLine(Mask,pts(q1,1),pts(q1,2),pts(q2,1),pts(q1,2));
%                          Mask = AddLine(Mask,pts(q2,1),pts(q2,2),pts(q2,1),pts(q1,2));
                      end
                      end
                  end
              end
           end            
        end
        
        if(p_ang(q1) < (0+ang_lim) && p_ang(q1) > (0-ang_lim)) %Ang = 0/90
           for q2 = 1:length(p_c)
              if(q2 ~= q1)
                  if(p_ang(q2) < (90+ang_lim) && p_ang(q2) > (90-ang_lim))   
                      dist_1 = p_dist(q1); %width
                      dist_2 = p_dist(q2); %height
                      ratio = dist_2./dist_1; %height/width
                      
                      area = dist_2*dist_1;
                      area_ratio = area/AREA;
                      if(area_ratio > area_lim)
                      if((ratio > ratio_liml) && (ratio < ratio_limu))
                         Quads(q_cnt) = struct('UL',pts(q2,:),'UR',[pts(q2,1),pts(q1,2)],'LL',pts(p,:),'LR',pts(q1,:));
                         q_cnt = q_cnt + 1;
%                          Mask = AddLine(Mask,pts(p,1),pts(p,2),pts(q2,1),pts(q2,2));
%                          Mask = AddLine(Mask,pts(p,1),pts(p,2),pts(q1,1),pts(q1,2));
%                          Mask = AddLine(Mask,pts(q1,1),pts(q1,2),pts(q2,1),pts(q1,2));
%                          Mask = AddLine(Mask,pts(q2,1),pts(q2,2),pts(q2,1),pts(q1,2));
                      end
                      end
                  end
              end
           end            
        end



        
    end
    
end
end

