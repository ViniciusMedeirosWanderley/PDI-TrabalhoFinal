function [Q] = MergeQuads(Q)

%     if(size(Q,2) >= 2)
%         Q = MergeQuad(Q,1);
%         Qpi = 2;
%         while(Qpi <= size(Q,2))
%             Q = MergeQuad(Q,Qpi);
%             Qpi = Qpi + 1;
%         end
%     end
%     
%     q_cnt = 1;
%     for i = 1:size(Q,2)
%        if(~isempty(Q(i).UL))
%            Q_o(q_cnt) = Q(i);
%            q_cnt = q_cnt + 1;
%        end
%     end
%     
    
    if(size(Q,2) > 1)

       sz_p = 0;
       l_cnt = size(Q,2);
       while(1)
           sz_p = size(Q,2);
           Q = MergeQuad(Q);
           sz_n = size(Q,2);

           %Swap last element with first element
           Q_save = Q(1);
           Q(1) = Q(sz_n);
           Q(sz_n) = Q_save;
           
           %Compare every element
           l_cnt = l_cnt - 1;
           %Need to compare everything again if something changes
           if((sz_p-sz_n)~=0)
               l_cnt = sz_n;
           end        
           
           if(l_cnt < 0)
               if(sz_n == sz_p)
                   break;
               end
           end
           
       end

      
      
        
    end

    


   
    
end