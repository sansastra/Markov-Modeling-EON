
% 2-HOP, link capacity=10 slices, d_k=3,4
Erlang_net1 =[0.05,0.1,0.15,0.2,0.25]/(2*3);

RF_net1= [1.885864e-03,4.688352e-03,8.299004e-03,1.261883e-02,1.755787e-02]; % 
RF_SC_net1= [1.830874e-03,4.480504e-03,7.857482e-03,1.187788e-02,1.646499e-02]; %[1.856080e-03,4.579607e-03,8.076257e-03,1.225907e-02,1.704819e-02]; % 
FF_net1=[4.418391e-04,1.708077e-03,3.714698e-03,6.383989e-03,9.644287e-03]; % 
FF_SC_net1=[4.239537e-04,1.634928e-03,3.548101e-03,6.086288e-03,9.179448e-03];

RF_net1_sim=[0.0018984218,0.004698965,0.008345471,0.012658743,0.017553834];
RF_SC_net1_sim=[0.001851453,0.0045867856,0.008052647,0.012225755,0.016985888]; %[0.0018687246,0.0046033086,0.008104864,0.012246317,0.017000297];
FF_net1_sim=[4.4647203E-4,0.0017228555,0.0037342003,0.006379291,0.009636006];
FF_SC_net1_sim=[4.453609E-4,0.0017165928,0.0037147051,0.0063340385,0.009559238];


% 3 -node ring,link capacity=7 slices, d_k= 3,4
Erlang_net2 =[0.001,0.008,0.05,0.1,0.15]/(2*6);

RF_net2= [3.832144e-04,3.053926e-03,1.867857e-02,3.643506e-02,5.334387e-02];
RF_SC_net2= [3.832964e-04,3.053477e-03,1.866009e-02,3.636737e-02,5.320464e-02];
FF_net2=[1.667842e-04,1.337649e-03,8.490031e-03,1.724678e-02,2.620786e-02];
FF_SC_net2=[1.667957e-04,1.337107e-03,8.467415e-03,1.715728e-02,2.600967e-02];

% 
RF_net2_sim=[3.8562E-4,0.003043649,0.018672556,0.0363885,0.053320512];
RF_SC_net2_sim=[3.8562E-4,0.003042942,0.018684775,0.03630697,0.053161275];
FF_net2_sim=[1.6652435E-4,0.0013148274,0.008487474,0.017241515,0.02624312];
FF_SC_net2_sim=[1.6652435E-4,0.0013146253,0.008474037,0.017187664,0.026122285];

figure;
subplot(1,2,1)
plot(Erlang_net1,RF_net1,'r-',Erlang_net1,RF_SC_net1,'g--',Erlang_net1,FF_net1,'b-',Erlang_net1,FF_SC_net1,'k--',...
     Erlang_net1,RF_net1_sim,'rd',Erlang_net1,RF_SC_net1_sim,'gd',Erlang_net1,FF_net1_sim,'bd',Erlang_net1,FF_SC_net1_sim,'kd');
legend('RF','RF-SC','FF','FF-SC','Sim');
xlabel('Arrival rate per class per route (\lambda_k^o)');
ylabel({'Blocking Probability'});

subplot(1,2,2)
plot(Erlang_net2,RF_net2,'r-',Erlang_net2,RF_SC_net2,'g--',Erlang_net2,FF_net2,'b-',Erlang_net2,FF_SC_net2,'k--',...
     Erlang_net2,RF_net2_sim,'rd',Erlang_net2,RF_SC_net2_sim,'gd',Erlang_net2,FF_net2_sim,'bd',Erlang_net2,FF_SC_net2_sim,'kd');
legend('RF','RF-SC','FF','FF-SC','Sim');
xlabel('Arrival rate per class per route (\lambda_k^o)');
ylabel({'Blocking Probability'});