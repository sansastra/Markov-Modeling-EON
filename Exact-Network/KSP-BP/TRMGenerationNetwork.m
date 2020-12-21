function transitionRateMatrix = TRMGenerationNetwork(arrivalRatePerClass,serviceRate,numberOfRoutes,...
                                                        transitionStatesForClasses,possibleStatesTransitionForClasses)

classes = length(transitionStatesForClasses(1,1,1,:));
numberOfStates = length(transitionStatesForClasses(:,1,1,1));
transitionRateMatrix=zeros(numberOfStates, numberOfStates);


    for i=1:numberOfStates
        for j=1:numberOfStates
            if(i~=j)
                for r=1:numberOfRoutes
                    for c=1:classes 
                        if (transitionStatesForClasses(i,j,r,c)==c)
                            transitionRateMatrix(i,j)=arrivalRatePerClass/possibleStatesTransitionForClasses(i,r,c); % defrag states arrival rates are caused by one or more classes
                        else if(transitionStatesForClasses(i,j,r,c)==-c)
                                transitionRateMatrix(i,j)= serviceRate; % only for random-fit
                            end
                        end
                    end
                end
            end

        end
         transitionRateMatrix(i,i)= -sum(transitionRateMatrix(i,:));
    end
 
end
