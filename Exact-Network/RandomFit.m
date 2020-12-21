function [stateOccupancyPattern,transitionForRoutesForClasses,blockingStates,possibleStatesTransitionForClasses]= RandomFit(WoSC,totalNumberOfSlots,bandwidthPerClass,routes)

classes=length(bandwidthPerClass);
numberOfRoutes=length(routes(:,1));
numberOfLinks = length(routes(1,:));
%Free =0; Used =1 and followd by remaingBandValue; 
remainingBand =-1;
stateOccupancyPattern={};
% initialize slot occupancy pattern 
for i=1:numberOfLinks 
    stateOccupancyPattern{i}(:,:)= zeros(1,totalNumberOfSlots);
end
validLinks={};
routeLength=zeros(1,numberOfRoutes);
for odPair=1:numberOfRoutes
    validLinks{odPair}=find(routes(odPair,:)==1);
    routeLength(odPair)=sum(routes(odPair,:));
end
% find out: in a given state, how many possible transition can happen due
% to arrivals of a class request
possibleStatesTransitionForClasses = [];
oldLength=0;    

% determines if a transition is possible from one state to another   
transitionForRoutesForClasses=[];

% find if a state is a blocking state for class c due to less resources
blockingStates=[];

% count connections per class per state
%connectionsPerClassPerState = zeros(1, classes); % last column indicates if a normal state is a defragmentated state or not

% Evaluate all possible connection incoming requests
if(WoSC)
    while(length(stateOccupancyPattern{1}(:,1))> oldLength)
        begin = oldLength+1;
        oldLength = length(stateOccupancyPattern{1}(:,1));
        for loop =begin : oldLength
            for odPair=1:numberOfRoutes 
                for c =1: classes
                    tempOccupancy=stateOccupancyPattern{validLinks{odPair}(1,1)}(loop,:); % just created for start of concatenation
                    for link=2:routeLength(odPair)
                        tempOccupancy=[tempOccupancy;stateOccupancyPattern{validLinks{odPair}(1,link)}(loop,:)];  
                    end
                        tempOccupancy=all(tempOccupancy==0,1); % column-wise check if all elements are zero
                        tempOccupancy=~tempOccupancy;
                        b = diff([0 tempOccupancy==0 0]);
                       max_res = find(b==-1) - find(b==1);
                      % MATLAB® evaluates compound expressions from left to right, adhering to operator precedence rules. 
                       if ((isempty(max_res)) || (max(max_res)<bandwidthPerClass(c))) % | => logical or
                           blockingStates(loop,odPair,c)=1;
                           possibleStatesTransitionForClasses(loop,odPair,c)=0;
                       else
%                            if(max_res<bandwidthPerClass(c))
%                              blockingStates(loop,odPair,c)=1;
%                              possibleStatesTransitionForClasses(loop,odPair,c)=0;
%                            else
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
                                       if(routes(odPair,link)==0)
                                           stateOccupancyTemp(link,:)=stateOccupancyPattern{link}(loop,:);
                                       else
                                           stateOccupancyTemp(link,:)=stateOccupancyPattern{link}(loop,:);
                                           stateOccupancyTemp(link,index1(i))=odPair;
                                           stateOccupancyTemp(link,index1(i)+1:index1(i)+bandwidthPerClass(c)-1)=remainingBand;
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
                          % end

                        end
                    end 
            end         
        end 

        % Evaluate all possible connection leaving-requests
        %not needed
    end
    
else % spectrum converter scenario
    while(length(stateOccupancyPattern{1}(:,1))> oldLength)


        begin = oldLength+1;
        oldLength = length(stateOccupancyPattern{1}(:,1));
        for loop =begin : oldLength
            for odPair=1:numberOfRoutes 
                for c =1: classes
                    tempOccupancy=stateOccupancyPattern{validLinks{odPair}(1,1)}(loop,:); % just created for start of concatenation
                    for link=2:routeLength(odPair)
                        tempOccupancy=[tempOccupancy;stateOccupancyPattern{validLinks{odPair}(1,link)}(loop,:)];                          
                    end
                    tempOccupancyBinary=all(tempOccupancy==0,1);
                    tempOccupancyBinary=~tempOccupancyBinary;
                    b = diff([0 tempOccupancyBinary==0 0]);
                    max_res = find(b==-1) - find(b==1);
                    if (isempty(max_res))| (max_res<bandwidthPerClass(c))
                        if(routeLength(odPair)==1)
                            blockingStates(loop,odPair,c)=1;
                            possibleStatesTransitionForClasses(loop,odPair,c)=0;
                            valid=0;
                        else
                            index1_local={};
                            valid=1;
                           % check whether individual link has sufficient free slices
                           for link =1:routeLength(odPair)
                               valid_local=0;
                               xx= find(tempOccupancy(link,:)==0);
                               for p=1:length(xx)-bandwidthPerClass(c)+1
                                   if (xx(p+bandwidthPerClass(c)-1)==xx(p)+bandwidthPerClass(c)-1) % finds if contiguos free slice
                                       valid_local=valid_local +1; 
                                       index1_local{link}(1,valid_local)=xx(p);

                                   end
                               end
                               if(valid_local==0)
                                   blockingStates(loop,odPair,c)=1;
                                   possibleStatesTransitionForClasses(loop,odPair,c)=0;
                                   valid=0;
                                   break;
                               else
                                   valid=valid*valid_local;
                               end
                           end
                           if(length(index1_local)==routeLength(odPair)) % % request is allocated without continuity
                               index1= zeros(numberOfLinks,valid);
                               % it will only work for request with 2 hops,change the code for 3-ho route by adding another loop
                               valid_local=1; % (i-1)*length(index1_local{2}(1,:))+j
                               for i=1:length(index1_local{1}(1,:)) % valid link 1
                                   for j= 1:length(index1_local{2}(1,:)) % valid link 2
                                       index1(validLinks{odPair}(1,1),valid_local)= index1_local{1}(1,i);
                                       index1(validLinks{odPair}(1,2),valid_local)= index1_local{2}(1,j);
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
                           if(routes(odPair,link)==0)
                               stateOccupancyTemp(link,:)=stateOccupancyPattern{link}(loop,:);
                           else
                               stateOccupancyTemp(link,:)=stateOccupancyPattern{link}(loop,:);
                               stateOccupancyTemp(link,index1(link,i))=odPair;
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
                end 
            end         
        %end 

        % Evaluate all possible connection leaving-requests

        %temp =length(stateOccupancyPattern{1}(:,1));
        %for loop=begin: temp

            for odPair=1:numberOfRoutes 
                occupancyPattern = stateOccupancyPattern{validLinks{odPair}(1,1)}(loop,:); 
                for link=2:routeLength(odPair)
                    occupancyPattern = [occupancyPattern;stateOccupancyPattern{validLinks{odPair}(1,link)}(loop,:)]; 
                end
                for c =1: classes % find connection location
                    validIndex={};
                    for link=1:routeLength(odPair)
                        index1=find(occupancyPattern(link,:)==odPair);
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
                        if(routeLength(odPair)==1)
                           index1= zeros(numberOfLinks,length(validIndex{1}(1,:)));
                           index1(validLinks{odPair}(1,1),:)=validIndex{1}(1,:);

                        else % 2-hops
                        
                            index1= zeros(numberOfLinks,length(validIndex{1}(1,:))*length(validIndex{2}(1,:)));
                            % it will only work for request with 2 hops,change the code for 3-ho route by adding another loop
                            valid_local=1; % (i-1)*length(index1_local{2}(1,:))+j
                            for i=1:length(validIndex{1}(1,:)) % valid link 1
                                for j= 1:length(validIndex{2}(1,:)) % valid link 2
                                    index1(validLinks{odPair}(1,1),valid_local)= validIndex{1}(1,i);
                                    index1(validLinks{odPair}(1,2),valid_local)= validIndex{2}(1,j);
                                    valid_local=valid_local+1;
                                end
                            end
                        end
                        for i=1:length(index1(1,:))
                            stateOccupancyTemp=zeros(numberOfLinks,totalNumberOfSlots);
                            for link=1:numberOfLinks %occupancy of all links forms a vector                                   
                                if(routes(odPair,link)==0)
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








