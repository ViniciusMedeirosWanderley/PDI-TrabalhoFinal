function [V2] = NumberLineRuns(V)

V2 = zeros(length(V),1);
V2(1) = V(1);
for i = 2:length(V)
    V2(i) = V(i).*(V2(i-1)+1);
end

rVi = fliplr(1:length(V2));

val = 1;
for i = 1:length(V2)
    
   if(V2(rVi(i)) > 0)
       if(val == 1)
          val = V2(rVi(i)); 
       else
          V2(rVi(i)) = val;
       end
   else
       val = 1;
   end
end


end