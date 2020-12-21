function [transitionStatesForClasses,blockingStates,possibleStatesTransitionForClasses]= NetworkTransition(classes,policy,stateIndex,bandwidthPerClass,...
                                                       routes,transitionStatesForClassesOLD,stateOccupancyPattern)

numberOfRoutes= length(routes(:,1));
numberOfLinks= length(stateIndex(1,:));

% guardBand=2;
% twoHopGB=3;
%numberOfLinkStates=length(stateOccupancyPattern(:,1));
% numberOfNetStates1Hop= length(stateIndex(:,1));
% % creat states for 2-hops
% stateIndex=[stateIndex;zeros(numberOfLinkStates-1,numberOfLinks)];
% stateOccupancyPattern=[stateOccupancyPattern;zeros(numberOfLinkStates-1,length(stateOccupancyPattern(1,:)))];
% for i=2:numberOfLinkStates
%     stateIndex(numberOfNetStates1Hop+i-1,:)=numberOfLinkStates+i-1;
%     stateOccupancyTemp=stateOccupancyPattern(i,:);
%     stateOccupancyTemp(stateOccupancyTemp==guardBand)=twoHopGB;
%     stateOccupancyPattern(numberOfLinkStates+i-1,:)=stateOccupancyTemp;
% end

numberOfNetStates=length(stateIndex(:,1));

transitionStatesForClasses= zeros(numberOfNetStates,numberOfNetStates,numberOfRoutes,classes);
blockingStates=zeros(numberOfNetStates,numberOfRoutes, classes);
possibleStatesTransitionForClasses=zeros(numberOfNetStates,numberOfRoutes, classes);
%connectionsPerClassPerState=zeros(numberOfNetStates,classes);

    for i=1:numberOfNetStates    
        src=stateIndex(i,:);        
        for c =1: classes            
            for j=1:numberOfNetStates
                if (i~=j)
                    dst=stateIndex(j,:);              
                    if (sum(src~=dst)==1) % it would occur due to 1-hop request
                        tt= find(src~=dst,1);                        
                        transitionStatesForClasses(i,j,tt,c)=transitionStatesForClassesOLD(src(tt),dst(tt),c);                       
                        
                    else
                        if (sum(src~=dst)==2) % it would occur due to 2-hop request
                            [arrAndDepart]= CheckTwoHopTransition(policy,src,dst,stateOccupancyPattern,bandwidthPerClass(c));
                            if(sum(arrAndDepart)~=0)% either arrival in i and/or departure from j
                               transitionStatesForClasses(i,j,numberOfRoutes,c)=arrAndDepart(1)*c;
                               transitionStatesForClasses(j,i,numberOfRoutes,c)=-arrAndDepart(2)*c;
                            end
                        end
                    end
                end
            end
            
            for r=1:numberOfRoutes
                tempOccupancy=stateOccupancyPattern(1,:);
                for link=1:numberOfLinks
                    if(routes(r,link)==1)
                        tempOccupancy=[tempOccupancy;stateOccupancyPattern(src(link),:)];
                    end 
                end
                tempOccupancy=all(tempOccupancy==0);
                tempOccupancy=~tempOccupancy;
                b = diff([0 tempOccupancy==0 0]);
               max_res = find(b==-1) - find(b==1);
               if (isempty(max_res))
                   blockingStates(i,r,c)=1;
               else
                   if(max_res<bandwidthPerClass(c))
                     blockingStates(i,r,c)=1;
                   else
                       if(policy==1)
                           possibleStatesTransitionForClasses(i,r,c)=1;
                       else
                           xx= find(tempOccupancy==0);                      
                           valid=0;
                           for p=1:length(xx)-bandwidthPerClass(c)+1
                               if (xx(p+bandwidthPerClass(c)-1)==xx(p)+bandwidthPerClass(c)-1) % finds if contiguos free slice
                                   valid=valid +1;                             
                               end
                           end
                           possibleStatesTransitionForClasses(i,r,c)=valid;
                       end
                   end
               end
            end
        end
    end
end

