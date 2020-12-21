%clc; 
% Number of slots
%clearvars;
%tic;
totalNumberOfSlots=5;
bandwidthPerClass = [3]; % including guard band so bandwidth must be > 2

serviceRate = 1.0;

policy =2; % 1 for first fit, and 2 for randomtFit 

%modelType=0 ; % 0 => no defragmentation; 
network_type=1; % 0=>a single link; 1=> 2-hop (KSP=1); 2 => special network ; 3 => 6-Node Ring; 
nr_ksp=1; % nr_ksp=1 or nr_ksp=2
WoSC =1 ; % 0 => without (1) or with (0)  spectrum conversion

initialLoad = 0.001; %[0.05,0.1,0.2,0.4,0.8];%[0.0012 0.012 0.12 0.6 1.2]; %[0.2 0.4 0.6 0.8 1]; %[0.05,0.1,0.15,0.2,0.25] ; %[0.001,0.008,0.05,0.1,0.15]; % 2-hop->[0.05,0.1,0.15,0.2,0.25]; 3-ring-> [0.001,0.008,0.05,0.1,0.15];

routes={};
switch(network_type)
    case 0 % 1-hop
        if(nr_ksp==1)
          routes{1}=1;
        else
           routes{1}=[1,0];
           routes{2}=[0,1];
        end
    case 1 % 2-hop
        routes{1}=[1,0;0,1;1,1];
        nr_ksp=1;
    case 2 % 3 node special network
        %  links : [0,1,2;
                  % 0,0,0;
                  % 0,3,0];
                  % 0,5,0,0];
        if(nr_ksp==1)
            routes{1}=[1,0,0; 
                       0,1,0;
                       0,0,1];
        else %if nr_ksp==2
            routes{1}=[1,0,0;
                       0,1,0;
                       0,0,1];
            routes{2}=[0,1,1; 0,0,0; 0,0,0];
        end
     case 3 % 3 node ring
        %  links : [0,1,2;
          % 3,0,4;
          % 5,6,0];
        if(nr_ksp==1)
            routes{1}=[1,0,0,0,0,0;0,1,0,0,0,0;
                       0,0,1,0,0,0;0,0,0,1,0,0;
                       0,0,0,0,1,0;0,0,0,0,0,1];
        else
%         all routes=[1->2; 1->3; 2->1; 2->3; 3->1; 3->2; 
%                  1->3->2; 1->2->3; 2->3->1; 2->1->3; 3->2->1; 3->1->2];            
            routes{1}=[1,0,0,0,0,0;0,1,0,0,0,0;
                       0,0,1,0,0,0;0,0,0,1,0,0;
                       0,0,0,0,1,0;0,0,0,0,0,1];
            routes{2}=[0,1,0,0,0,1;1,0,0,1,0,0;
                       0,0,0,1,1,0;0,1,1,0,0,0;
                       0,0,1,0,0,1;1,0,0,0,1,0];
        end   
end
                         
 
numberOfODpairs=length(routes{1}(:,1));
numberOfLinks = length(routes{1}(1,:));

totalRunNo=length(initialLoad);
classes=length(bandwidthPerClass);
if(policy==1)
    [stateOccupancyPattern,transitionForRoutesForClasses,blockingStates,possibleStatesTransitionForClasses]= FirstFit(WoSC,totalNumberOfSlots,bandwidthPerClass,routes,nr_ksp);
else if(policy==2)
        [stateOccupancyPattern,transitionForRoutesForClasses,blockingStates,possibleStatesTransitionForClasses]= RandomFit(WoSC,totalNumberOfSlots,bandwidthPerClass,routes,nr_ksp);
    end
end

numberOfStates = length(stateOccupancyPattern{1}(:,1))
% stateIndex = zeros(numberOfStates^numberOfLinks,numberOfLinks);
% factor2=numberOfStates;
% for link=1:numberOfLinks
%     factor1=numberOfStates^(numberOfLinks-link);
%     s=1;
%     for cycle = 1: numberOfStates^(link-1)
%         for i= 1:factor2
%            for k= 1: factor1
%                stateIndex(s,link)=i;          
%                s=s+1;            
%            end
%         end
%         
%     end
%    
% end
% 
% numberOfStates = length(stateIndex(:,1))
% if(numberOfLinks~=1)
%  [transitionStatesForClasses,blockingStates,possibleStatesTransitionForClasses]= NetworkTransition(classes,policy,stateIndex,bandwidthPerClass,...
%                                                        routes,transitionStatesForClasses,stateOccupancyPattern);
% end


% Calculate Transition rate matrix





overallBlockingProbability=zeros(classes,totalRunNo);

for runNo=1:totalRunNo
loadPerLink =  initialLoad(runNo); %initialLoad*runNo;

% for unioform distribution
arrivalRatePerClass= loadPerLink/(classes*numberOfODpairs); %sum(bandwidthPerClass);


transitionRateMatrix = TRMGenerationNetwork(arrivalRatePerClass,serviceRate,numberOfODpairs,...
              transitionForRoutesForClasses,possibleStatesTransitionForClasses);
   
    
%transitionRateMatrix = TransitionRateMatrixGeneration(arrivalRatePerClass,serviceRate,transitionStatesForClasses);

%transitionRateMatrix
% if(simulation==1)
%     stateProbabilities = MCMC(transitionRateMatrix); 
% else
index1=find(diag(transitionRateMatrix)==0);
tempRow= ones(1,numberOfStates);
for i=1: length(index1)
    tempRow(index1(i))=0;
end
temptransitionRateMatrix = [transpose(transitionRateMatrix);tempRow];
 %temptransitionRateMatrix = [temptransitionRateMatrix ;ones(1,numberOfMacroStates)];
 index1=find(diag(temptransitionRateMatrix)==0);
 if(~isempty(index1))
     temptransitionRateMatrix(index1(1),:)=[];
 else
     temptransitionRateMatrix = temptransitionRateMatrix(2:numberOfStates+1,:);
 end

% temptransitionRateMatrix = transpose(transitionRateMatrix);
% temptransitionRateMatrix = [temptransitionRateMatrix ;ones(1,numberOfStates)];
% index1=find(diag(temptransitionRateMatrix)==0,1);
% 
%  if(index1||index2)
%      temptransitionRateMatrix(index1,:)=[];
%  else
%      index2=find(diag(temptransitionRateMatrix)==-0,1);
%      if(index2)
%          temptransitionRateMatrix(index2,:)=[];
%      else
%          temptransitionRateMatrix = temptransitionRateMatrix(2:numberOfStates+1,:);
%      end
%  end


% solve equation Ax=b
b = [zeros(numberOfStates-1,1);1];
[stateProbabilities] = lsqr(temptransitionRateMatrix,b,1e-8,1000000);
if(sum(stateProbabilities<0))%-0.0000000001))
    disp('error in state Probabilities')
    index1=find(stateProbabilities<0);
    for i=1:length(index1)
        %fprintf('%d,',stateProbabilities(index1(i))); 
        stateProbabilities(index1(i))=0.0000000000001;
    end
end
%end


 
% find blocking probabilities
%%% find state probabilities of NB and Blocking States

% occupancyPerState=connectionsPerClassPerState*transpose(bandwidthPerClass);
% uniqueStates=unique(occupancyPerState);
% uniqueError= zeros(1,length(uniqueStates));
% for i=2:length(uniqueStates)
%     index1= find(uniqueStates(i)==occupancyPerState);
%     A=zeros(1,length(index1));
%     for j=1:length(index1)
%         A(j)=stateProbabilities(index1(j));
%         %%% print to check 
%         if(uniqueStates(i)==8)
%            fprintf('%d,',A(j));
%         end
%     end
%     uniqueError(i)= var(A);
% end
% fprintf('\n%s','unique Error = ')
% for k=1:length(uniqueError)
%     fprintf('%d,',uniqueError(k));   
% end  

%%%%%% calculate probability of acceptance p_k(x)

% occupancyPerState=connectionsPerClassPerState*transpose(bandwidthPerClass);
% uniqueStates=unique(occupancyPerState);
% exactProb= zeros(classes,length(uniqueStates));
% approxProb=zeros(classes,length(uniqueStates));
% for i=1:length(uniqueStates)
%     index1= find(uniqueStates(i)==occupancyPerState);
%     
%     for k=1: classes 
%         A=0;
%         for j=1:length(index1)
%             if(connectionNonBlockingStates(index1(j),k))
%                exactProb(k,i)= exactProb(k,i)+stateProbabilities(index1(j));
%                approxProb(k,i)=approxProb(k,i)+1;
%             end
%             A = A+stateProbabilities(index1(j));
%         end
%         exactProb(k,i)= exactProb(k,i)/A;
%         approxProb(k,i)=approxProb(k,i)/length(index1);
%     end
% end
% fprintf('\n%s','Exact probability of acceptance = ')
% for s=1:length(uniqueStates)
%     fprintf('%d,',sum(exactProb(:,s))/classes);   
% end 
% fprintf('\n%s','Approx probability of acceptance = ')
% for s=1:length(uniqueStates)
%     fprintf('%d,',sum(approxProb(:,s))/classes);   
% end 
    
blockingProbabilityPerClass= zeros(1,classes);

for c =1: classes
    sum1=0; 
    for odPair=1:numberOfODpairs
           
        for n =1: numberOfStates
                if(blockingStates(n,odPair,c)==1)
                    sum1 =sum1+ stateProbabilities(n);
                end 
        end
    end
    blockingProbabilityPerClass(c)= sum1/numberOfODpairs;
end
overallBlockingProbability(runNo) = sum(blockingProbabilityPerClass)/classes;

end



%toc;

% fprintf('\n%s','totalResourceBlockingProbability= ')
% for k=1:totalRunNo
%     fprintf('%d,',totalResourceBlockingProbability(k));   
% end
% fprintf('\n%s','totalFragmentationBlockingProbability= ')
% for k=1:totalRunNo
%     fprintf('%d,',totalFragmentationBlockingProbability(k));   
% end

fprintf('\n%s','overallBlockingProbability = ')
for k=1:totalRunNo
    fprintf('%d,',overallBlockingProbability(k));   
end

% fprintf('\n%s','Average Queue Length = ')
% for k=1:totalRunNo
%     fprintf('%d,',avgQueueLength(k));   
% end

% fprintf('\n%s','overallBlockingProbabilityPerClass = ')
% for c=1:classes
%     for k=1:totalRunNo
%         fprintf('%d,',overallBlockingProbabilityPerClass(c,k));   
%     end
%     fprintf('\n')
% end
