% INFOCOM 2020 %%%%%%%%%%%%%
%%%%%%% Probability of Acceptance %%%%
% C=20, d=(3,4,5), load=1.2

% plot probability of acceptance
%p_k_x_exact_RF=[1,1,1,1,1,1,9.966144e-01,9.858671e-01,9.547406e-01,8.534895e-01,7.663404e-01,6.532156e-01,4.923878e-01,3.102919e-01,1.444398e-01,5.522086e-02,0,0,0]; %[1,1,9.365904e-01,4.063021e-01,1.632899e-01,0,0,0];
%p_k_x_approx1_RF=[1,1,1,1,1,1,9.963370e-01,9.602564e-01,9.134199e-01,8.484848e-01,7.355556e-01,5.908497e-01,4.308390e-01,2.736661e-01,1.326531e-01,4.047619e-02,0,0,0]; %[1,1,9.285714e-01,4.000000e-01,1.500000e-01,0,0,0];
%p_k_x_approx2_RF=[1,1,1,1,1,1,9.995614e-01,9.943088e-01,9.858300e-01,9.724614e-01,9.476589e-01,9.130455e-01,8.714825e-01,8.271610e-01,5.336107e-01,2.573269e-01,0,0,0];

p_k_x_exact_FF=[1,1,1,1,1,1,9.990736e-01,9.960082e-01,9.937742e-01,9.859524e-01,9.508236e-01,8.935583e-01,8.081850e-01,7.567169e-01,5.014065e-01,2.532552e-01,0,0,0];%[1,1,9.248534e-01,8.828901e-01,4.625122e-01,0,0,0];
p_k_x_approx1_FF=[1,1,1,1,1,1,9.950980e-01,9.579832e-01,9.162534e-01,8.609113e-01,7.712091e-01,6.610455e-01,5.282359e-01,3.739219e-01,1.985380e-01,6.468798e-02,0,0,0];%[1,1,8.750000e-01,7.142857e-01,3.750000e-01,0,0,0];
%p_k_x_approx2_FF_old=[1,1,1,1,1,1,9.994226e-01,9.940421e-01,9.863725e-01,9.747953e-01,9.547596e-01,9.279239e-01,8.932890e-01,8.506154e-01,5.496202e-01,2.633222e-01,0,0,0];
p_k_x_approx2_FF=[1,1,1,1,1,1,9.999248e-01,9.990379e-01,9.974142e-01,9.945664e-01,9.891722e-01,9.811650e-01,9.699333e-01,9.550587e-01,6.293603e-01,3.098406e-01,0,0,0];
p_k_x_Uniform=[1.0000,1.0000,0.9952,0.9720,0.9203,0.8399,0.7378,0.6226,0.5018,0.3825,0.2721,0.1778,0.1042,0.0526,0.0211,0.0053,0,0,0];

Kaufmann=[ones(1,14),0.6667,0.3333,0,0,0]; % p_k(x=16)= (1+1+0)/3
Binomial=0.9405*ones(1,19);
Erlang=[0,3:1:20];
%figure;
%plot(Erlang,p_k_x_exact_FF,'rx-',Erlang,p_k_x_approx1_FF,'r>-',Erlang,p_k_x_approx2_FF,'rd-',Erlang,p_k_x_exact_RF,'g.-',Erlang,p_k_x_approx1_RF,'go-',Erlang,p_k_x_approx2_RF,'rp-');
%legend('FF, Exact','FF, App.EES','FF, App.SOC','RF, Exact','RF, App.EES','RF, App.SOC');
%subplot(1,2,1)
% plot(Erlang,p_k_x_exact_RF,'r.-',Erlang,p_k_x_approx1_RF,'go-',Erlang,p_k_x_approx2_RF,'b>-',Erlang,p_k_x_Uniform,'m+-',Erlang,Kaufmann,'kx--',Erlang,Binomial,'c*--');
% legend('Exact','App.EES','App.SOC','App.Uni', 'Kaufmann', 'Binomial');
% xlabel('Number of Occupied Slices (x)');
% ylabel({'Avg. Probability of Acceptance in RF'});
% figure;
% %subplot(1,2,2)
% plot(Erlang,p_k_x_exact_FF,'r.-',Erlang,p_k_x_approx1_FF,'go-',Erlang,p_k_x_approx2_FF,'b>-',Erlang,Binomial,'kx--');%,Erlang,p_k_x_Uniform,'m+-',Erlang,Kaufmann,'kx--');
% legend('Exact','App.EES','App.COS','Binomial');%,'App.Uni', 'Kaufmann');
% xlabel('Number of Occupied Slices (x)');
% ylabel({'Avg. Probability of Acceptance in FF'});

% loads 0.1 and 1.2
ApproxErrorL1FF = [0,5.142993e-05,5.474364e-05,5.852654e-05,2.387660e-09,2.755068e-09,3.225803e-09,1.238105e-09,3.663026e-10,1.926830e-13,1.883572e-13,...
                        1.356943e-13,6.045122e-14,2.028060e-14,3.083682e-17,3.424966e-17,3.315214e-17,2.735560e-17,2.547772e-17];
ApproxErrorL2FF =[0,4.358877e-04,4.189680e-04,4.084048e-04,2.168700e-06,2.351779e-06,2.584560e-06,9.534222e-07,2.808534e-07,1.953544e-08,1.891321e-08,...
                   1.323911e-08,5.809889e-09,2.036845e-09,4.753094e-10,6.009040e-10,6.069735e-10,4.571880e-10,3.462134e-10];

% ApproxErrorL1RF =[0,7.869143e-11,1.356786e-10,2.560982e-10,1.125202e-14,3.553658e-14,1.027351e-13,8.760049e-12,3.857637e-12,1.328759e-17,2.674689e-16,...
%                       5.255605e-16,4.266135e-16,2.040434e-16,6.922939e-20,1.676117e-19,2.251068e-19,1.906796e-19,1.101072e-19];
% ApproxErrorL2RF =[0,1.946312e-07,3.089609e-07,5.048358e-07,3.357732e-10,5.394797e-10,9.472723e-10,1.955052e-08,8.284073e-09,3.842774e-12,8.311852e-11,...
%     1.544112e-10,1.193146e-10,5.667979e-11,3.161087e-12,7.717440e-12,1.062964e-11,9.296649e-12,6.256983e-12];                  


% figure;
% Erlang=[0, 3:1:20];
% plot(Erlang,ApproxErrorL1FF,'rx-',Erlang,ApproxErrorL2FF,'g>-');
% legend('FF, offered load = 0.1','FF, offered load = 1.2');
% xlabel('Number of Occupied Slices (x)');
% ylabel({'Variance of State Probabilities'});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2-links , C=100,  d=[3,4,6]
Erlang_net1 =[10 15 20 25 30];

FF_C1_sim=[2.6940625E-5,0.0026766611,0.024980577,0.075469166,0.13701786];
FF_SC_C1_sim=[1.9389663E-5,0.0021702498,0.02151063,0.06914987,0.13099524];
FF_DF_C1_sim=[4.4408284E-6,8.866491E-4,0.011871233,0.047968905,0.1051882];

RF_C1_app2= [5.962198e-05,1.694941e-03,1.192635e-02,4.298335e-02,9.652123e-02]; % 
RF_SC_C1_app2= [4.101099e-05,1.291490e-03,1.067051e-02,4.197088e-02,9.615998e-02]; % 
RF_DF_C1_app2=[1.095462e-05,9.197401e-04,1.031182e-02,4.195815e-02,9.601226e-02];
Binomial_C1= [2.988605e-04,1.103881e-02,5.208178e-02,1.184108e-01,2.158841e-01]; % 

figure;
subplot(1,2,1);
plot(Erlang_net1,FF_C1_sim,'go-',Erlang_net1,RF_C1_app2,'gx--',Erlang_net1,FF_DF_C1_sim,'r.-',Erlang_net1,RF_DF_C1_app2,'r*--',Erlang_net1,Binomial_C1,'k-');
legend('FF (Sim.)','FF (App.)','FF-DF (Sim.)','FF-DF (App.)','Binomial');
xlabel('Offered Load (Erlangs)');
ylabel({'Blocking Probability'});

% 2-links , C=200,  d=[4,6,10]
Erlang_net1 =[15 20 25 30 35];


FF_C2_sim=[1.9292782E-5,0.0010298885,0.009780929,0.035031814,0.07364821];
FF_SC_C2_sim=[1.5252318E-5,8.201918E-4,0.008162434,0.03081234,0.06782679];
FF_DF_C2_sim=[3.6906595E-6,2.3694673E-4,0.0033818518,0.017543377,0.047840994];

RF_C2_app2= [1.813686e-05,5.625756e-04,4.543838e-03,1.749814e-02,4.435714e-02]; % 
RF_SC_C2_app2= [1.284866e-05,4.236510e-04,3.781375e-03,1.617377e-02,4.338232e-02]; % 
RF_DF_C2_app2=[1.006952e-05,4.012021e-04,3.855186e-03,1.653807e-02,4.374865e-02];
Binomial_C2= [2.070381e-02,7.056603e-02,1.327423e-01,2.233204e-01,3.274972e-01]; % 

subplot(1,2,2);
plot(Erlang_net1,FF_C2_sim,'go-',Erlang_net1,RF_C2_app2,'gx--',Erlang_net1,FF_DF_C2_sim,'r.-',Erlang_net1,RF_DF_C2_app2,'r*--');%,Erlang_net1,Binomial_C2,'k-');
legend('FF (Sim.)','FF (App.)','FF-DF (Sim.)','FF-DF (App.)');%,'Binomial');
xlabel('Offered Load (Erlangs)');
ylabel({'Blocking Probability'});

%%%%%%%%%%% 10-hops %%%%%%%%%%%%%%%%%%%
% 10-links , C=100,  d=[3,4,6]
Erlang_net1 =[10 15 20 25 30]; 

FF_C1_sim=[3.4697898E-6,5.584314E-4,0.008254755,0.034394275,0.075458966];
FF_SC_C1_sim=[2.2451154E-6,3.1166754E-4,0.004920197,0.02299405,0.055615734];
FF_DF_C1_sim=[0.0,8.7152155E-5,0.0020216291,0.012576508,0.037580375];

RF_C1_app2= [3.766911e-05,1.390188e-03,9.753566e-03,2.922458e-02,5.774360e-02]; % 
RF_SC_C1_app2= [7.526870e-06,3.355751e-04,3.387935e-03,1.579764e-02,4.305152e-02]; % 
RF_DF_C1_app2=[2.752901e-06,3.397553e-04,4.855750e-03,2.128597e-02,5.005877e-02];


Binomial= [3.118301e-01,3.494181e-01,3.722531e-01,3.828133e-01,3.910106e-01]; % 


figure;
subplot(1,2,1);
plot(Erlang_net1,FF_C1_sim,'go-',Erlang_net1,RF_C1_app2,'gx--',Erlang_net1,FF_DF_C1_sim,'r.-',Erlang_net1,RF_DF_C1_app2,'r*--');%,Erlang_net1,FF_SC_C1_sim,'bp-',Erlang_net1,RF_SC_C1_app2,'b+--');
legend('FF (Sim.)','FF (App.)','FF-DF (Sim.)','FF-DF (App.)');%,'FF-SC (Sim.)','FF-SC (App.)');
xlabel('Offered Load (Erlangs)');
ylabel({'Blocking Probability'});

% subplot(2,2,2);
% plot(Erlang_net1,FF_SC_C1_sim,'go-',Erlang_net1,RF_SC_C1_app2,'gx--',);
% legend('FF-SC (Sim.)','FF-SC (App.)','FF-DF (Sim.)','FF-DF (App.)');
% xlabel('Offered Load (Erlangs)');
% ylabel({'Blocking Probability'});

% 10-links , C=200,  d=[4,6,10]
Erlang_net1 =[15 20 25 30 35];

FF_C2_sim=[1.4144081E-6,1.5216453E-4,0.00225926,0.011797577,0.032141473];

FF_SC_C2_sim=[1.1113312E-6,7.8102894E-5,0.0012354131,0.007101703,0.021274166];
FF_DF_C2_sim=[4.0817633E-7,1.673617E-5,3.5309812E-4,0.0027021437,0.010851439];

RF_C2_app2= [4.159357e-06,1.745175e-04,2.065095e-03,9.719491e-03,2.517213e-02]; % 
RF_SC_C2_app2= [9.347342e-07,4.629655e-05,6.558756e-04,3.993228e-03,1.384136e-02]; % 
RF_DF_C2_app2=[1.473471e-06,9.415291e-05,1.357530e-03,7.388012e-03,2.118200e-02];

Binomial= [3.460377e-01,3.699541e-01,3.860427e-01,3.985551e-01,4.090027e-01]; % 

subplot(1,2,2);
plot(Erlang_net1,FF_C2_sim,'go-',Erlang_net1,RF_C2_app2,'gx--',Erlang_net1,FF_DF_C2_sim,'r.-',Erlang_net1,RF_DF_C2_app2,'r*--',Erlang_net1,FF_SC_C2_sim,'bp-',Erlang_net1,RF_SC_C2_app2,'b+--');
legend('FF (Sim.)','FF (App.)','FF-DF (Sim.)','FF-DF (App.)','FF-SC (Sim.)','FF-SC (App.)');
xlabel('Offered Load (Erlangs)');
ylabel({'Blocking Probability'});

% subplot(2,2,4);
% plot(Erlang_net1,FF_SC_C2_sim,'go-',Erlang_net1,RF_SC_C2_app2,'gx--',Erlang_net1,FF_DF_C2_sim,'r.-',Erlang_net1,RF_DF_C2_app2,'rx--');
% legend('FF-SC (Sim.)','FF-SC (App.)','FF-DF (Sim.)','FF-DF (App.)');
% xlabel('Offered Load (Erlangs)');
% ylabel({'Blocking Probability'});


% NSFNET C=10, d=[3,4], [0.6,1.2,2.4,4.8,9.6]

% NSFNET C=100, d=[3,4,6], 
Erlang_C1=[100,150,200,250,300];

FF_K1_C1=[3.644515e-04,5.287520e-03,2.451398e-02,6.120302e-02,1.081862e-01];  
FF_SC_K1_C1=[1.760669e-04,3.790462e-03,2.170974e-02,5.825504e-02,1.058616e-01]; 
FF_DF_K1_C1=[1.464382e-04,4.043989e-03,2.245251e-02,5.917791e-02,1.065758e-01];

FF_K1_C1_sim=[5.676051E-4,0.016136032,0.06263671,0.1214223,0.17798366];
FF_SC_K1_C1_sim=[3.3012123E-4,0.009037223,0.03907891,0.08476388,0.1350797];
FF_DF_K1_C1_sim=[1.03664956E-4,0.0044606747,0.025878573,0.06716234,0.11810058]; 

FF_K2_C1=[2.772423e-07,5.554771e-05,1.376804e-03,1.357654e-02,5.756816e-02];
FF_SC_K2_C1=[3.336667e-08,1.431767e-05,7.332774e-04,1.119279e-02,5.583075e-02];
FF_DF_K2_C1=[2.311317e-08,2.307511e-05,1.018514e-03,1.257764e-02,5.663579e-02];

FF_K2_C1_sim =[1.1108566E-6,0.001787277,0.03192455,0.09144483,0.15227206];
FF_SC_K2_C1_sim=[2.0399737E-7,2.6092888E-4,0.007973187,0.0427947,0.09824607];
FF_DF_K2_C1_sim=[0.0,0.0,0.0,2.0399737E-7,2.5095675E-5];

%%%%%%% NSFNET C=200, d=[4,6,10], 
Erlang_C2=[100,150,200,250,300];

FF_K1_C2=[2.816454e-06,3.011341e-04,3.182314e-03,1.327129e-02,3.395492e-02]; 
FF_K2_C2=[4.194471e-12,6.855929e-08,1.246677e-05,3.005634e-04,2.997565e-03];

FF_K1_C2_sim=[1.377551e-05,5.208763e-04,4.236452e-03,3.363014e-02,8.602078e-02];
FF_K2_C2_sim=[0.0,1.2117118E-6,7.6907314E-4,0.014334793,0.049477387];

FF_SC_K1_C2=[1.243312e-06,1.602146e-04,2.247597e-03,1.140526e-02,3.144057e-02];  
FF_SC_K2_C2=[4.564354e-13,1.027638e-08,3.251902e-06,1.391883e-04,2.038611e-03];

FF_SC_K1_C2_sim=[2.243971E-6,4.778107E-4,0.006210765,0.02308931,0.050069794];
FF_SC_K2_C2_sim=[0.0,4.0390395E-7,1.05723906E-4,0.0027848007,0.017186353];

FF_DF_K1_C2=[1.438529e-06,2.169642e-04,2.755921e-03,1.248865e-02,3.291029e-02]; 
FF_DF_K2_C2=[7.710564e-13,3.364796e-08,8.646551e-06,2.508352e-04,2.756967e-03];

FF_DF_K1_C2_sim=[1.243971E-7,0.0001,0.0026,0.0133,0.04]; %check
FF_DF_K2_C2_sim=[0.0,1.0390395E-7,5.05723906E-5,0.0007848007,0.007186353]; % verify

figure;
subplot(1,2,1);
plot(Erlang_C1,FF_K1_C1,'r.-',Erlang_C1,FF_K2_C1,'g.-',Erlang_C1,FF_DF_K1_C1,'k.-',Erlang_C1,FF_DF_K2_C1,'b.-',...
     Erlang_C1,FF_K1_C1_sim,'rd--',Erlang_C1,FF_K2_C1_sim,'gd--',Erlang_C1,FF_DF_K1_C1_sim,'kd--');
legend('App. FF,\kappa_o=1','App. FF,\kappa_o=2','App. FF-DF,\kappa_o=1','App. FF-DF,\kappa_o=2','Sim. FF,\kappa_o=1','Sim. FF,\kappa_o=2','Sim. FF-DF,\kappa_o=1');
xlabel('Offered Load (Erlang)');
ylabel({'Blocking Probability'});

subplot(1,2,2);
plot(Erlang_C1,FF_SC_K1_C1,'b.-',Erlang_C1,FF_SC_K2_C1,'k.-',...
     Erlang_C1,FF_SC_K1_C1_sim,'bd--',Erlang_C1,FF_SC_K2_C1_sim,'kd--');
legend('App. FF-SC,\kappa_o=1','App. FF-SC,\kappa_o=2','Sim. FF-SC,\kappa_o=1','Sim. FF-SC,\kappa_o=2');
xlabel('Offered Load (Erlang)');
ylabel({'Blocking Probability'});

figure
subplot(1,2,1);
plot(Erlang_C2,FF_K1_C2,'r.-',Erlang_C2,FF_K2_C2,'g.-',Erlang_C2,FF_DF_K1_C2,'k.-',Erlang_C2,FF_DF_K2_C2,'b.-',...
     Erlang_C2,FF_K1_C2_sim,'rd--',Erlang_C2,FF_K2_C2_sim,'gd--',Erlang_C2,FF_DF_K1_C2_sim,'kd--');
legend('App. FF,\kappa_o=1','App. FF,\kappa_o=2','App. FF-DF,\kappa_o=1','App. FF-DF,\kappa_o=2','Sim. FF,\kappa_o=1','Sim. FF,\kappa_o=2','Sim. FF-DF,\kappa_o=1');
xlabel('Offered Load (Erlang)');
ylabel({'Blocking Probability'})

subplot(1,2,2);
plot(Erlang_C2,FF_SC_K1_C2,'b.-',Erlang_C2,FF_SC_K2_C2,'k.-',...
     Erlang_C2,FF_SC_K1_C2_sim,'bd--',Erlang_C2,FF_SC_K2_C2_sim,'kd--');
legend('App. FF-SC,\kappa_o=1','App. FF-SC,\kappa_o=2','Sim. FF-SC,\kappa_o=1','Sim. FF-SC,\kappa_o=2');
xlabel('Offered Load (Erlang)');
ylabel({'Blocking Probability'})