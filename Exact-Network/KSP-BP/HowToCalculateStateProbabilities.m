% Assign arrival rate per class if same, if different initialize in a an array
arrivalRatePerClass = 0.5;
departurerate = 1;
numberOfStates = 3 ;
classes = 1; % assume only one class
%suppose we have 3 states 0, 1 and 2, 
%based on arrival rates and departure form transition rate matrix
transitionRateMatrix =  [-0.5, 0.5,0;...
                         1, -1.5, 0.5; ...
                         0, 1, -1];
 
%Since we have to solve Pi times Q = 0, and  sum of state probabilities (pi) is 1,
%we have 1 extra equation than unknowns, so we append a row of 1s, and remove an extra row from Q                  

temptransitionRateMatrix = [transpose(transitionRateMatrix);ones(1,numberOfStates)];
temptransitionRateMatrix = temptransitionRateMatrix(2:numberOfStates+1,:);
 

% Use lsqr to solve equation Ax=b
b = [zeros(numberOfStates-1,1);1];
[stateProbabilities] = lsqr(temptransitionRateMatrix,b,1e-8,1000000)
    
% now you can compute Blocking etc using state probabilities


