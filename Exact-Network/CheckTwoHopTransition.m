function [arrAndDepart]= CheckTwoHopTransition(policy,src,dst,stateOccupancyPattern,bandwidth)
    guardBand=2;
    arrAndDepart=[0 0]; %[0 0]=> target state cant be mapped, 
                       %[1 1]=> 0=> target state can be mapped by both arrival and departure
                       %[0 1]=> target state can be mapped due to departure only
    %possibilities=0; % total number of possible transitions

    
   zero_col=all([stateOccupancyPattern(src(1),:);stateOccupancyPattern(src(2),:)]==0); % to find continuos free slice 
   zero_col=~zero_col;
   b = diff([0 zero_col==0 0]);
   max_res = find(b==-1) - find(b==1);
   if (isempty(max_res))
       return;
   else
       if(max_res<bandwidth)
           return;
       end
   end
   xx= find(zero_col==0); 
   index1=0;
   valid=0;
   for i=1:length(xx)-bandwidth+1
       if (xx(i+bandwidth-1)==xx(i)+bandwidth-1) % finds if contiguos free slice
           valid=valid +1;
           index1(valid)=xx(i);
       end
   end
   
   for i=1: valid
       srcStateOccupancyTemp=stateOccupancyPattern(src(1),:);
       srcStateOccupancyTemp(index1(i))=guardBand;
       srcStateOccupancyTemp(index1(i)+1:index1(i)+bandwidth-2)=1;
       srcStateOccupancyTemp(index1(i)+bandwidth-1)=2;
       if(isequal(srcStateOccupancyTemp,stateOccupancyPattern(dst(1),:)))
           srcStateOccupancyTemp=stateOccupancyPattern(src(2),:);
           srcStateOccupancyTemp(index1(i))=guardBand;
           srcStateOccupancyTemp(index1(i)+1:index1(i)+bandwidth-2)=1;
           srcStateOccupancyTemp(index1(i)+bandwidth-1)=2;
           if(isequal(srcStateOccupancyTemp,stateOccupancyPattern(dst(2),:)))                   
               if(policy==2)
                   arrAndDepart=[1 1];  
                   %possibilities=valid;                      
               else
                   if (i==1) % FF policy
                      arrAndDepart=[1 1];
                   else
                       arrAndDepart=[0 1]; 
                   end
                   %possibilities=1;
               end
               break;
           end
       end
   end
      
end
           
                       
                   
                   

        

    