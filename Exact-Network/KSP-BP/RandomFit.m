function [stateOccupancyPattern,transitionForRoutesForClasses,blockingStates,possibleStatesTransitionForClasses]= RandomFit(WoSC,totalNumberOfSlots,bandwidthPerClass,routes,nr_ksp)

classes=length(bandwidthPerClass);
numberOfODpairs=length(routes{1}(:,1));
numberOfLinks = length(routes{1}(1,:));
%Free =0; Used =1 and followd by remaingBandValue; 
remainingBand =-1;
stateOccupancyPattern={};
% initialize slot occupancy pattern 
for i=1:numberOfLinks 
    stateOccupancyPattern{i}(:,:)= zeros(1,totalNumberOfSlots);
end
validLinks={};
routeLength=zeros(nr_ksp,numberOfODpairs);
nr_ksp_ODpair= zeros(1,numberOfODpairs);
for odPair=1:numberOfODpairs
    count1=0;
    for ksp=1:nr_ksp
        if(sum(routes{ksp}(odPair,:))>0)
           validLinks{ksp,odPair}=find(routes{ksp}(odPair,:)==1);
           routeLength(ksp,odPair)=sum(routes{ksp}(odPair,:));
           count1= count1+1;
        end
    end
    nr_ksp_ODpair(odPair)= count1;
end
% find out: in a given state, how many possible transition can happen due
% to arrivals of a class request
possibleStatesTransitionForClasses = [];
oldLength=0;    

% determines if a transition is possible from one state to another   
transitionForRoutesForClasses=[];

% find if a state is a blocking state for class c due to less resources
blockingStates=[];

% Evaluate all possible connection incoming requests
if(WoSC)
    while(length(stateOccupancyPattern{1}(:,1))> oldLength)
        begin = oldLength+1;
        oldLength = length(stateOccupancyPattern{1}(:,1));
        for loop =begin : oldLength
            for odPair=1:numberOfODpairs 
                for c =1: classes
                    blocking_routes=0;
                    for ksp=1:nr_ksp_ODpair(odPair) 
                        tempOccupancy=stateOccupancyPattern{validLinks{ksp,odPair}(1,1)}(loop,:); % just created for start of concatenation
                        for link=2:routeLength(ksp,odPair)
                            tempOccupancy=[tempOccupancy;stateOccupancyPattern{validLinks{ksp,odPair}(1,link)}(loop,:)];  
                        end
                        tempOccupancy=all(tempOccupancy==0,1); % column-wise check if all elements are zero
                        tempOccupancy=~tempOccupancy;
                        b = diff([0 tempOccupancy==0 0]);
                       max_res = find(b==-1) - find(b==1);
                      % MATLAB® evaluates compound expressions from left to right, adhering to operator precedence rules. 
                       if ((isempty(max_res)) || (max(max_res)<bandwidthPerClass(c)))
                           blocking_routes=blocking_routes+1;
                           if(blocking_routes==nr_ksp_ODpair(odPair))
                              blockingStates(loop,odPair,c)=1;
                              possibleStatesTransitionForClasses(loop,odPair,c)=0;
                           end
                       else
                           blockingStates(loop,odPair,c)=0;
                           possibleStatesTransitionForClasses(loop,odPair,c)=0;
                           xx= find(tempOccupancy==0);                      
                           valid=0;
                           index1=0;
                           for p=1:length(xx)-bandwidthPerClass(c)+1
                               if (xx(p+bandwidthPerClass(c)-1)==xx(p)+bandwidthPerClass(c)-1) % finds if contiguos free slice
                                   valid=valid +1; 
                                   index1(valid)=xx(p);
                               end
                           end
                           possibleStatesTransitionForClasses(loop,odPair,c)=valid;
                           for i=1: valid
                               stateOccupancyTemp=zeros(numberOfLinks,totalNumberOfSlots);
                               for link=1:numberOfLinks %occupancy of all links forms a vector                                   
                                   if(routes{ksp}(odPair,link)==0)
                                       stateOccupancyTemp(link,:)=stateOccupancyPattern{link}(loop,:);
                                   else
                                       stateOccupancyTemp(link,:)=stateOccupancyPattern{link}(loop,:);
                                       stateOccupancyTemp(link,index1(i))=(ksp-1)*numberOfODpairs +odPair; % this is the route number 
                                       stateOccupancyTemp(link,index1(i)+1:index1(i)+bandwidthPerClass(c)-1)=remainingBand;
                                   end
                               end

                               counter = OccupancyVectorFound(stateOccupancyTemp,stateOccupancyPattern,numberOfLinks);
                               if(counter) % occupancy vector found
                                  transitionForRoutesForClasses(loop,counter,odPair,c)=c; % 1 for arrival                      
                                  %transitionForRoutesForClasses(counter,loop,odPair,c)=-c; % 2 for departure      
                               else
                                   for link=1:numberOfLinks
                                       stateOccupancyPattern{link}(length(stateOccupancyPattern{link}(:,1))+1,:)=stateOccupancyTemp(link,:);
                                   end
                                   % only for random (de)allocation
                                   transitionForRoutesForClasses(loop,length(stateOccupancyPattern{1}(:,1)),odPair,c)=c; % 1 for arrival                      
                                   %transitionForRoutesForClasses(length(stateOccupancyPattern{1}(:,1)),loop,odPair,c)=-c; % 2 for departure
                               end
                           end
                       break;
                      % end
                      end                    
                   end
               end 
           end         
        
        % Evaluate all possible connection leaving-requests
            for odPair=1:numberOfODpairs 
                for ksp=1:nr_ksp_ODpair(odPair) 
                    %if ~isempty(validLinks{ksp,odPair}) % second condition is useful when there is no secondary routes
                        occupancyPattern = stateOccupancyPattern{validLinks{ksp,odPair}(1,1)}(loop,:); 
                        index1=find(occupancyPattern==((ksp-1)*numberOfODpairs +odPair)); % occupancy on OD pair routes
                        for c =1: classes % find connection location
                            validIndex=zeros(1,length(index1)) ;
                            for i=1:length(index1)
                                if(index1(i)+bandwidthPerClass(c)<=totalNumberOfSlots)
                                    if((sum(occupancyPattern(index1(i)+1:index1(i)+bandwidthPerClass(c))==remainingBand)==bandwidthPerClass(c)-1)&&(occupancyPattern(index1(i)+bandwidthPerClass(c))~=remainingBand))
                                       validIndex(i)= index1(i); 
                                    end
                                else
                                    if(sum(occupancyPattern(index1(i)+1:totalNumberOfSlots)==remainingBand)==bandwidthPerClass(c)-1 )
                                       validIndex(i)= index1(i); 
                                    end
                                end
                            end
                            validIndex=validIndex(find(validIndex>0));

                            for i=1:length(validIndex)
                                stateOccupancyTemp=zeros(numberOfLinks,totalNumberOfSlots);
                                for link=1:numberOfLinks %occupancy of all links forms a vector                                   
                                    if(routes{ksp}(odPair,link)==0)
                                       stateOccupancyTemp(link,:)=stateOccupancyPattern{link}(loop,:);
                                    else
                                       stateOccupancyTemp(link,:)=stateOccupancyPattern{link}(loop,:);
                                       stateOccupancyTemp(link,validIndex(i):validIndex(i)+bandwidthPerClass(c)-1)=0;
                                    end
                                end
                                counter = OccupancyVectorFound(stateOccupancyTemp,stateOccupancyPattern,numberOfLinks);
                                if(counter) % occupancy vector found
                                    transitionForRoutesForClasses(loop,counter,odPair,c)=-c; % 2 for departure      
                                else

                                    for link=1:numberOfLinks
                                       stateOccupancyPattern{link}(length(stateOccupancyPattern{link}(:,1))+1,:)=stateOccupancyTemp(link,:);
                                    end
                                    % only for random (de)allocation
                                    transitionForRoutesForClasses(loop,length(stateOccupancyPattern{1}(:,1)),odPair,c)=-c; % for departure                     
                                end
                            end
                        end
                    %end
                end
             end
        end
    end
    
else % spectrum converter scenario
    while(length(stateOccupancyPattern{1}(:,1))> oldLength)
        begin = oldLength+1;
        oldLength = length(stateOccupancyPattern{1}(:,1));
        for loop =begin : oldLength
            for odPair=1:numberOfODpairs 
                for c =1: classes  
                    blocking_routes=0;
                    for ksp=1:nr_ksp_ODpair(odPair)
                        valid=0;
                        tempOccupancy=stateOccupancyPattern{validLinks{ksp,odPair}(1,1)}(loop,:); % just created for start of concatenation
                        for link=2:routeLength(ksp,odPair)
                            tempOccupancy=[tempOccupancy;stateOccupancyPattern{validLinks{ksp,odPair}(1,link)}(loop,:)];                          
                        end
                        tempOccupancyBinary=all(tempOccupancy==0,1);
                        tempOccupancyBinary=~tempOccupancyBinary;
                        b = diff([0 tempOccupancyBinary==0 0]);
                        max_res = find(b==-1) - find(b==1);
                        if (isempty(max_res))|| (max(max_res)<bandwidthPerClass(c))
                            if(routeLength(ksp,odPair)==1)
                                blocking_routes=blocking_routes+1;
                                if(blocking_routes==nr_ksp_ODpair(odPair))
                                   blockingStates(loop,odPair,c)=1;
                                   possibleStatesTransitionForClasses(loop,odPair,c)=0;
                                end
                                valid=0;
                            else
                                index1_local={};
                                valid=1;
                               % check whether individual link has sufficient free slices
                               for link =1:routeLength(ksp,odPair)
                                   valid_local=0;
                                   xx= find(tempOccupancy(link,:)==0);
                                   for p=1:length(xx)-bandwidthPerClass(c)+1
                                       if (xx(p+bandwidthPerClass(c)-1)==xx(p)+bandwidthPerClass(c)-1) % finds if contiguos free slice
                                           valid_local=valid_local +1; 
                                           index1_local{link}(1,valid_local)=xx(p);

                                       end
                                   end
                                   if(valid_local==0)
                                       blocking_routes=blocking_routes+1;
                                        if(blocking_routes==nr_ksp_ODpair(odPair))
                                           blockingStates(loop,odPair,c)=1;
                                           possibleStatesTransitionForClasses(loop,odPair,c)=0;
                                           valid=0;
                                           break;
                                        end
                                   else
                                       valid=valid*valid_local;
                                   end
                               end
                               if(length(index1_local)==routeLength(ksp,odPair)) % % request is allocated without continuity
                                   index1= zeros(numberOfLinks,valid);
                                   % it will only work for request with 2 hops,change the code for 3-ho route by adding another loop
                                   valid_local=1; % (i-1)*length(index1_local{2}(1,:))+j
                                   for i=1:length(index1_local{1}(1,:)) % valid link 1
                                       for j= 1:length(index1_local{2}(1,:)) % valid link 2
                                           index1(validLinks{ksp,odPair}(1,1),valid_local)= index1_local{1}(1,i);
                                           index1(validLinks{ksp,odPair}(1,2),valid_local)= index1_local{2}(1,j);
                                           valid_local=valid_local+1;
                                       end
                                   end
                                   blockingStates(loop,odPair,c)=0;
                                   possibleStatesTransitionForClasses(loop,odPair,c)=valid;
                               end
                            end

                        else % request is allocated with continuity
                           xx= find(tempOccupancyBinary==0);                      
                           valid=0;
                           index1=zeros(numberOfLinks,1);
                           for p=1:length(xx)-bandwidthPerClass(c)+1
                               if (xx(p+bandwidthPerClass(c)-1)==xx(p)+bandwidthPerClass(c)-1) % finds if contiguos free slice
                                   valid=valid +1; 
                                   index1(1:numberOfLinks,valid)=xx(p); % here slot index for allocation is place on all links 
                               end
                           end
                           blockingStates(loop,odPair,c)=0;
                           possibleStatesTransitionForClasses(loop,odPair,c)=valid;
                        end

                       for i=1: valid
                           stateOccupancyTemp=zeros(numberOfLinks,totalNumberOfSlots);
                           for link=1:numberOfLinks %occupancy of all links forms a vector                                   
                               if(routes{ksp}(odPair,link)==0)
                                   stateOccupancyTemp(link,:)=stateOccupancyPattern{link}(loop,:);
                               else
                                   stateOccupancyTemp(link,:)=stateOccupancyPattern{link}(loop,:);
                                   stateOccupancyTemp(link,index1(link,i))=(ksp-1)*numberOfODpairs +odPair; % this is the route number 
                                   stateOccupancyTemp(link,index1(link,i)+1:index1(link,i)+bandwidthPerClass(c)-1)=remainingBand;
                               end
                           end

                           counter = OccupancyVectorFound(stateOccupancyTemp,stateOccupancyPattern,numberOfLinks);
                           if(counter) % occupancy vector found
                              transitionForRoutesForClasses(loop,counter,odPair,c)=c; % 1 for arrival                      
                              transitionForRoutesForClasses(counter,loop,odPair,c)=-c; % 2 for departure      
                           else
                               for link=1:numberOfLinks
                                   stateOccupancyPattern{link}(length(stateOccupancyPattern{link}(:,1))+1,:)=stateOccupancyTemp(link,:);
                               end
                               % only for random (de)allocation
                               transitionForRoutesForClasses(loop,length(stateOccupancyPattern{1}(:,1)),odPair,c)=c; % 1 for arrival                      
                               transitionForRoutesForClasses(length(stateOccupancyPattern{1}(:,1)),loop,odPair,c)=-c; % 2 for departure
                           end
                       end
                       if(valid>0)
                           break;
                       end
                    end 
                end
            end         
        %end 

        % Evaluate all possible connection leaving-requests

        %temp =length(stateOccupancyPattern{1}(:,1));
        %for loop=begin: temp

            for odPair=1:numberOfODpairs 
                for ksp=1:nr_ksp_ODpair(odPair)                 
                    occupancyPattern = stateOccupancyPattern{validLinks{ksp,odPair}(1,1)}(loop,:); 
                    for link=2:routeLength(ksp,odPair)
                        occupancyPattern = [occupancyPattern;stateOccupancyPattern{validLinks{ksp,odPair}(1,link)}(loop,:)]; 
                    end
                    for c =1: classes % find connection location
                        validIndex={};
                        for link=1:routeLength(ksp,odPair)
                            index1=find(occupancyPattern(link,:)==((ksp-1)*numberOfODpairs +odPair));
                            validIndex_link=zeros(1,length(index1)) ;
                            for i=1:length(index1)
                                if(index1(i)+bandwidthPerClass(c)<=totalNumberOfSlots)
                                    if((sum(occupancyPattern(link,index1(i)+1:index1(i)+bandwidthPerClass(c))==remainingBand)==bandwidthPerClass(c)-1)&&(occupancyPattern(link,index1(i)+bandwidthPerClass(c))~=remainingBand))
                                       validIndex_link(i)= index1(i); 
                                    end
                                else
                                    if(sum(occupancyPattern(link,index1(i)+1:totalNumberOfSlots)==remainingBand)==bandwidthPerClass(c)-1 )
                                       validIndex_link(i)= index1(i); 
                                    end
                                end
                            end
                            validIndex{link}(:)=validIndex_link(find(validIndex_link>0));
                        end
                        if(~isempty(validIndex{1}(:)))
                            if(routeLength(ksp,odPair)==1)
                               index1= zeros(numberOfLinks,length(validIndex{1}(1,:)));
                               index1(validLinks{ksp,odPair}(1,1),:)=validIndex{1}(1,:);

                            else % 2-hops

                                index1= zeros(numberOfLinks,length(validIndex{1}(1,:))*length(validIndex{2}(1,:)));
                                % it will only work for request with 2 hops,change the code for 3-ho route by adding another loop
                                valid_local=1; % (i-1)*length(index1_local{2}(1,:))+j
                                for i=1:length(validIndex{1}(1,:)) % valid link 1
                                    for j= 1:length(validIndex{2}(1,:)) % valid link 2
                                        index1(validLinks{ksp,odPair}(1,1),valid_local)= validIndex{1}(1,i);
                                        index1(validLinks{ksp,odPair}(1,2),valid_local)= validIndex{2}(1,j);
                                        valid_local=valid_local+1;
                                    end
                                end
                            end
                            for i=1:length(index1(1,:))
                                stateOccupancyTemp=zeros(numberOfLinks,totalNumberOfSlots);
                                for link=1:numberOfLinks %occupancy of all links forms a vector                                   
                                    if(routes{ksp}(odPair,link)==0)
                                       stateOccupancyTemp(link,:)=stateOccupancyPattern{link}(loop,:);
                                    else
                                       stateOccupancyTemp(link,:)=stateOccupancyPattern{link}(loop,:);
                                       stateOccupancyTemp(link,index1(link,i):index1(link,i)+bandwidthPerClass(c)-1)=0;
                                    end
                                end
                                counter = OccupancyVectorFound(stateOccupancyTemp,stateOccupancyPattern,numberOfLinks);
                                if(counter) % occupancy vector found
                                    transitionForRoutesForClasses(loop,counter,odPair,c)=-c; % 2 for departure      
                                else

                                    for link=1:numberOfLinks
                                       stateOccupancyPattern{link}(length(stateOccupancyPattern{link}(:,1))+1,:)=stateOccupancyTemp(link,:);
                                    end
                                    % only for random (de)allocation
                                    transitionForRoutesForClasses(loop,length(stateOccupancyPattern{1}(:,1)),odPair,c)=-c; % for departure                     
                                end
                            end
                        end
                    end
                end
            end
        end
    end    
end
end








