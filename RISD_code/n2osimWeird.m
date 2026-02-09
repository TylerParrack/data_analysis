%% load dataMatrix
cd('C:\Users\tyler\Desktop\IR Spectra\Data\numbers\polarization\sepcalave') %set this to data path
load('anBmimV2_03032022sepcalave.mat') %will load in as data, crop_data
%% NEW NEW NEW
%% start N2O parallel
ADD_TO_STARTUP
w1 = [2180 2250]; %change these!!!
w3 = [2180 2248];
% crop_data = cropData(Bmimn2oRTv2avesepcal.zzzz([1:4]),w1,w3);
% 
% clear dyn
% dyn = aDArrayBnd;%first time call empty, later can call with indices
% 
% %Orientation relaxation
% label = 'Orientation_rel';
% oPara = @(T1,t2,T3,p) (1/9).*exp(-T1./(3.*p.tau_o2)).*(1+4/5.*exp(-t2./p.tau_o2)).*exp(-T3./(3*p.tau_o2));
% oPerp = @(T1,t2,T3,p) (1/9).*exp(-T1./(3.*p.tau_o2)).*(1-2/5.*exp(-t2./p.tau_o2)).*exp(-T3./(3*p.tau_o2));
% oCrossed = @(T1,t2,T3,p) 1/15.*exp(-T1./(3.*p.tau_o2)).*exp(-t2./p.tau_o2).*exp(-T3./(3*p.tau_o2));
% oMagic = @(T1,t2,T3,p) 1/9.*exp(-T1./(3.*p.tau_o2)).*exp(-T3./(3*p.tau_o2));%need to checkprefactors
% fun_array = {oPara};
% ind_array = {[1:32]};
% dynParams2 = fitParamBnd('tau_o2',36,0.1,150,'');
% dyn(1) = aDArrayBnd(label,fun_array,ind_array,dynParams2,'free');%change this to dyn(2) when you put kinetics back in

%% SO if you're not going to fit for kinetics its best to turn *OFF* the diagrams relating to anything
%other than the main bands.

%cheat to turn some diagrams off and on

%  label = 'cheat';
%  on = @(T1,t2,T3,p) 1;
%  off = @(T1,t2,T3,p) 0;
%  fun_array = {off,on};
%  ind_array = {[20 23 25 26 27 28 29 30 31 32 8 11 7 10  9 12 14 17 13 16 15 18 19 22 21 24  ...
%              ],[ 1 4 2 5 3 6 ]};
%  dynParams3 = fitParamBnd('onoff',0,0,1,'fixed');
%  dyn(2) = aDArrayBnd(label,fun_array,ind_array,dynParams3,'');
% %%
% clear lsfParams
% %singleexp
% lsfParams(1) = fitParamBnd('Delta1_cm',0.01,0.001,50,''); 
% lsfParams(2) = fitParamBnd('tau1',0.2,0.1,500,'');
% lsfParams(3) = fitParamBnd('Delta2_cm',4.4,0.01,50,''); 
% lsfParams(4) = fitParamBnd('tau2',67,0.1,500,'');
% lsfParams(5) = fitParamBnd('T2',1.1,0.1,50,'');
% lsf = lsf2exp1fastBnd(lsfParams,'free');
% 
% 
% %
% scans = [1:length(crop_data)];
% clear aRFoptions s;
% aRFoptions.dt = 0.2;
% aRFoptions.n_t = 64;
% aRFoptions.n_zp = 2*aRFoptions.n_t;
% aRFoptions.flag_rotating_frame = true;
% aRFoptions.w_01_cm = fitParamBnd('w_01_cm',2225.7,2220,2230,'fixed');
% aRFoptions.dw_sb_cm = fitParamBnd('dw_sb_cm',13,10,15,'fixed');
% %aRFoptions.mu01sq = fitParamBnd('mu01sq',6.21,0,25,'fixed');x
% aRFoptions.mu01sq = fitParamBnd('mu01sq',0.2,0.0000001,1.5,'free');
% aRFoptions.mu12sqRatio = fitParamBnd('mu12sqRatio',1.72,0.1,2.5,'free');
% aRFoptions.anh_cm = fitParamBnd('anh_cm',30,0,40,'fixed');
% aRFoptions.phase_deg = fitParamBnd('phase_deg',0,-90,90,'fixed');
% aRFoptions.damping = lsf;
% aRFoptions.dyn = dyn;
% aRFoptions.dE_cm = fitParamBnd('dE_cm',600,590,700,'fixed');
% aRFoptions.temperature = fitParamBnd('temperature',295,290,505,'fixed');
% aRFoptions.t2_array = [crop_data(scans).t2]./1000;
% aRFoptions.w1_in = crop_data(1).w1; 
% aRFoptions.w3_in = (crop_data(1).w3);
% aRFoptions.useParallel=false;  
% aRFoptions.nboot = 20;
% 
% 
% 
% s = aRFCO2Bnd(aRFoptions);
% 
% %
% s = s.calcSpectrum(s.p0)
% 
% s.dataMatrix = prepareGlobalFitData(crop_data(scans))/(1e3); 
% 
% %
% nscans = zeros(1,length(scans));
% for ii = 1:length(scans)
%     nscans(ii) = crop_data(scans(ii)).PARAMS.nScans;
% end
% 
% %
% wt = nScansToWeights(s(1).dataMatrix,nscans);
% s.weightMatrix = wt;
% 
%  %% chi by eye
% 
% % compare across all of them
% % close all
% matrixPlot2DIR(s.dataMatrix, s.w1_in,s.w3_in,s.t2_array,[5 6],'height_px',100,'zlimit',1) %data
% matrixPlot2DIR(s.simMatrix,s.w1_in,s.w3_in,s.t2_array,[5 6],'height_px',100,'zlimit',1) %sim
% matrixPlot2DIR(s.simMatrix-s.dataMatrix,s.w1_in,s.w3_in,s.t2_array,[5 6],'height_px',100) %residuals
% 
% %% lets see if the fitting algorithm can get us closer
% s = s.globalFitW;
% %%
% s = s.calcSpectrum(s.pfit); %now re-simulate the data with the 'new' numbers
% 
% matrixPlot2DIR(s.dataMatrix, s.w1_in,s.w3_in,s.t2_array,[5 6],'height_px',100,'zlimit',1) %data
% matrixPlot2DIR(s.simMatrix,s.w1_in,s.w3_in,s.t2_array,[5 6],'height_px',100,'zlimit',1) %sim
% matrixPlot2DIR(s.simMatrix-s.dataMatrix,s.w1_in,s.w3_in,s.t2_array,[5 6],'height_px',100) %residuals

%%
syms k_u k_d k_hgs10 k_hgs00 t


K = [-k_u,       k_hgs00,            k_d,        0;
        0,  -k_hgs00-k_hgs10-k_u,    0,         k_d;
      k_u,       k_hgs10,           -k_d,      k_hgs00;
        0,         k_u,              0,       -k_hgs00-k_d];

[V3, D3] = eig(K);
ev3 = diag(D3);


V3_0 = [1; 0; 0; 0];

p3 = V3*expm(D3*t)*V3^(-1);
V3_t = p3*V3_0;

A =  matlabFunction(V3_t(1),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
B = matlabFunction(V3_t(2),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
C = matlabFunction(V3_t(3),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
D = matlabFunction(V3_t(4),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);

V3_0 = [0; 1; 0; 0];

p3 = V3*expm(D3*t)*V3^(-1);
V3_t = p3*V3_0;

E =  matlabFunction(V3_t(1),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
F = matlabFunction(V3_t(2),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
G = matlabFunction(V3_t(3),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
H = matlabFunction(V3_t(4),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);

V3_0 = [0; 0; 1; 0];

p3 = V3*expm(D3*t)*V3^(-1);
V3_t = p3*V3_0;

I = matlabFunction(V3_t(1),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
J = matlabFunction(V3_t(2),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
K = matlabFunction(V3_t(3),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
L = matlabFunction(V3_t(4),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);

V3_0 = [0; 0; 0; 1];

p3 = V3*expm(D3*t)*V3^(-1);
V3_t = p3*V3_0;

M = matlabFunction(V3_t(1),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
N = matlabFunction(V3_t(2),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
O = matlabFunction(V3_t(3),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
P = matlabFunction(V3_t(4),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);

%%
AA = @(T1,t2,T3,p) A(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
BB = @(T1,t2,T3,p) B(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
CC = @(T1,t2,T3,p) C(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
DD = @(T1,t2,T3,p) D(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
EE = @(T1,t2,T3,p) E(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
FF = @(T1,t2,T3,p) F(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
GG = @(T1,t2,T3,p) G(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
HH = @(T1,t2,T3,p) H(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
II = @(T1,t2,T3,p) I(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
JJ = @(T1,t2,T3,p) J(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
KK = @(T1,t2,T3,p) K(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
LL = @(T1,t2,T3,p) L(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
MM = @(T1,t2,T3,p) M(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
NN = @(T1,t2,T3,p) N(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
OO = @(T1,t2,T3,p) O(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
PP = @(T1,t2,T3,p) P(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);

%% NEW NEW NEW
%% start N2O

crop_data = cropData(Bmimn2oRTv2avesepcal.zzzz,w1,w3);

clear dyn
dyn = aDArrayBnd;%first time call empty, later can call with indices
label = 'kinetics';
fun_array = {AA BB CC DD ... 
             EE FF GG HH ...
             II JJ KK LL...
             MM NN OO PP};
         
ind_array = {[1 4], [], [13 16], [],...
            [27 28], [2 5 3 6], [25 26], [14 17 15 18],...
            [19 22], [], [7 10], [],...
            [31 32], [20 23 21 24], [29 30], [8 11 9 12]};
dynParams1    = fitParamBnd('k_u',0.0028,0.00001,1,'');
dynParams1(2) = fitParamBnd('k_hgs10',0.014,1e-10,1,'');
dynParams1(3) = fitParamBnd('k_hgs00',0.000016,1e-10,0.5,'');
dynParams1(4) = fitParamBnd('k_d',1,1e-10,1.5,'');
dyn(1) = aDArrayBnd(label,fun_array,ind_array,dynParams1,'free');

%Orientation relaxation
label = 'Orientation_rel';
oPara = @(T1,t2,T3,p) (1/9).*exp(-T1./(3.*p.tau_o2)).*(1+4/5.*exp(-t2./p.tau_o2)).*exp(-T3./(3*p.tau_o2));
oPerp = @(T1,t2,T3,p) (1/9).*exp(-T1./(3.*p.tau_o2)).*(1-2/5.*exp(-t2./p.tau_o2)).*exp(-T3./(3*p.tau_o2));
oCrossed = @(T1,t2,T3,p) 1/15.*exp(-T1./(3.*p.tau_o2)).*exp(-t2./p.tau_o2).*exp(-T3./(3*p.tau_o2));
oMagic = @(T1,t2,T3,p) 1/9.*exp(-T1./(3.*p.tau_o2)).*exp(-T3./(3*p.tau_o2));%need to checkprefactors
fun_array = {oPara};
ind_array = {[1:32]}; %says which feynman pathways
dynParams2 = fitParamBnd('tau_o2',1.04,0.01,900,'');
dyn(2) = aDArrayBnd(label,fun_array,ind_array,dynParams2,'free');%change this to dyn(2) when you put kinetics back in

%%
clear lsfParams
% %bi exp
lsfParams(1) = fitParamBnd('Delta1_cm',4.4,0.1,500,''); %for biexp 2.4
lsfParams(2) = fitParamBnd('tau1',18.6,0.1,500,''); %for biexp 0.6
% lsfParams(3) = fitParamBnd('Delta2_cm',4.2,0.1,500,''); 
% lsfParams(4) = fitParamBnd('tau2',24.6,0.1,500,'');
lsfParams(5) = fitParamBnd('T2',4.58,4.58,4.58,'');
lsf = lsf1exp1fastBnd(lsfParams,'free');


scans = [1:length(crop_data)];
clear aRFoptions s;
aRFoptions.dt = 0.2;
aRFoptions.n_t = 64;
aRFoptions.n_zp = 2*aRFoptions.n_t;
aRFoptions.flag_rotating_frame = true;
aRFoptions.w_01_cm = fitParamBnd('w_01_cm',2225.7,2220,2230,'fixed');
aRFoptions.dw_sb_cm = fitParamBnd('dw_sb_cm',13,10,20,'fixed');
%aRFoptions.mu01sq = fitParamBnd('mu01sq',6.21,0,25,'fixed');x
aRFoptions.mu01sq = fitParamBnd('mu01sq',0.088,0.0000001,1.5,'fixed');
aRFoptions.mu12sqRatio = fitParamBnd('mu12sqRatio',1.62,0.1,2.5,'fixed');
aRFoptions.anh_cm = fitParamBnd('anh_cm',30,0,40,'fixed');
aRFoptions.phase_deg = fitParamBnd('phase_deg',-1.6,-90,90,'fixed');
aRFoptions.dyn = dyn;
aRFoptions.dE_cm = fitParamBnd('dE_cm',600,590,900,'fixed');
aRFoptions.temperature = fitParamBnd('temperature',295,290,505,'fixed');
aRFoptions.t2_array = [crop_data(scans).t2]./1000;
aRFoptions.w1_in = crop_data(1).w1; 
aRFoptions.w3_in = (crop_data(1).w3);
aRFoptions.useParallel=false;  
aRFoptions.nboot = 50;

aRFoptions.damping = lsf;


s = aRFCO2Bnd(aRFoptions);

%
s = s.calcSpectrum(s.p0);


%s.dataMatrix = prepareGlobalFitData(PEGDA_2d_crop); 
s.dataMatrix = prepareGlobalFitData(crop_data(scans))/(1e4); 

%
nscans = zeros(1,length(scans));
for ii = 1:length(scans)
    nscans(ii) = crop_data(scans(ii)).PARAMS.nScans;
end

%
wt = nScansToWeights(s(1).dataMatrix,nscans);
s.weightMatrix = wt;

 %% chi by eye

% compare across all of them
% close all
matrixPlot2DIR(s.dataMatrix, s.w1_in,s.w3_in,s.t2_array,[5 6],'height_px',100,'zlimit',1) %data
matrixPlot2DIR(s.simMatrix,s.w1_in,s.w3_in,s.t2_array,[5 6],'height_px',100,'zlimit',1) %sim
matrixPlot2DIR(s.simMatrix-s.dataMatrix,s.w1_in,s.w3_in,s.t2_array,[5 6],'height_px',100) %residuals
%% lets see if the fitting algorithm can get us closer
s = s.globalFitW;
%%
s = s.calcSpectrum(s.pfit); %now re-simulate the data with the 'new' numbers

matrixPlot2DIR(s.dataMatrix, s.w1_in,s.w3_in,s.t2_array,[5 6],'height_px',100,'zlimit',1) %data
matrixPlot2DIR(s.simMatrix,s.w1_in,s.w3_in,s.t2_array,[5 6],'height_px',100,'zlimit',1) %sim
matrixPlot2DIR(s.simMatrix-s.dataMatrix,s.w1_in,s.w3_in,s.t2_array,[5 6],'height_px',100) %residuals

%% lets do multimethod to fit para and perp at the same time



close all
clear dyn

w1 = [2200 2250]; %change these!!!
w3 = [2185 2248];
crop_data(1,1:29) = cropData(Bmimn2oRTv2avesepcal.zzzz,w1,w3);
crop_data(2,1:29) = cropData(Bmimn2oRTv2avesepcal.zzxx,w1,w3);

syms k_u k_d k_hgs10 k_hgs00 t


K = [-k_u,       k_hgs00,            k_d,        0;
        0,  -k_hgs00-k_hgs10-k_u,    0,         k_d;
      k_u,       k_hgs10,           -k_d,      k_hgs00;
        0,         k_u,              0,       -k_hgs00-k_d];

[V3, D3] = eig(K);
ev3 = diag(D3);


V3_0 = [1; 0; 0; 0];

p3 = V3*expm(D3*t)*V3^(-1);
V3_t = p3*V3_0;

A =  matlabFunction(V3_t(1),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
B = matlabFunction(V3_t(2),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
C = matlabFunction(V3_t(3),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
D = matlabFunction(V3_t(4),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);

V3_0 = [0; 1; 0; 0];

p3 = V3*expm(D3*t)*V3^(-1);
V3_t = p3*V3_0;

E =  matlabFunction(V3_t(1),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
F = matlabFunction(V3_t(2),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
G = matlabFunction(V3_t(3),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
H = matlabFunction(V3_t(4),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);

V3_0 = [0; 0; 1; 0];

p3 = V3*expm(D3*t)*V3^(-1);
V3_t = p3*V3_0;

I = matlabFunction(V3_t(1),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
J = matlabFunction(V3_t(2),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
K = matlabFunction(V3_t(3),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
L = matlabFunction(V3_t(4),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);

V3_0 = [0; 0; 0; 1];

p3 = V3*expm(D3*t)*V3^(-1);
V3_t = p3*V3_0;

M = matlabFunction(V3_t(1),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
N = matlabFunction(V3_t(2),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
O = matlabFunction(V3_t(3),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);
P = matlabFunction(V3_t(4),'Vars',[k_u,k_d,k_hgs10,k_hgs00,t]);

%%
AA = @(T1,t2,T3,p) A(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
BB = @(T1,t2,T3,p) B(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
CC = @(T1,t2,T3,p) C(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
DD = @(T1,t2,T3,p) D(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
EE = @(T1,t2,T3,p) E(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
FF = @(T1,t2,T3,p) F(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
GG = @(T1,t2,T3,p) G(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
HH = @(T1,t2,T3,p) H(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
II = @(T1,t2,T3,p) I(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
JJ = @(T1,t2,T3,p) J(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
KK = @(T1,t2,T3,p) K(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
LL = @(T1,t2,T3,p) L(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
MM = @(T1,t2,T3,p) M(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
NN = @(T1,t2,T3,p) N(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
OO = @(T1,t2,T3,p) O(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);
PP = @(T1,t2,T3,p) P(p.k_u,p.k_u/(2*exp(-p.dE_cm/(0.69503476*p.temperature))),p.k_hgs10,p.k_hgs00,t2);

%%

dyn = aDArrayBnd;%first time call empty, later can call with indices
label = 'kinetics';
fun_array = {AA BB CC DD ... 
             EE FF GG HH ...
             II JJ KK LL...
             MM NN OO PP};
         
ind_array = {[1 4], [], [13 16], [],...
            [27 28], [2 5 3 6], [25 26], [14 17 15 18],...
            [19 22], [], [7 10], [],...
            [31 32], [20 23 21 24], [29 30], [8 11 9 12]};
dynParams1    = fitParamBnd('k_u',0.0026,0.00001,1,'');
dynParams1(2) = fitParamBnd('k_hgs10',0.014,1e-10,1,'');
dynParams1(3) = fitParamBnd('k_hgs00',0.0,0,0.01,'');
dynParams1(4) = fitParamBnd('k_d',1,1,1,'');
dyn(1) = aDArrayBnd(label,fun_array,ind_array,dynParams1,'fixed');

%T1 population relaxation
% label = 'T1_rel';
% f1 = @(T1,t2,T3,p) exp(-T1./(2*p.T1_rel)).*exp(-T3./(2*p.T1_rel));
% f2 = @(T1,t2,T3,p) exp(-T1./(2*p.T1_rel)).* exp(-t2./p.T1_rel).*exp(-T3./(2*p.T1_rel));
% f3 = @(T1,t2,T3,p) exp(-T1./(2*p.T1_rel)).*(1-exp(-t2./p.T1_rel)).*exp(-T3./(2*p.T1_rel));
% fun_array = {f1, f2, f3};
% ind_array = {[1 4], [2 3 5 6], [7 8]};  %says which feynman pathways
% dynParams1 = fitParamBnd('T1_rel',10,0.1,500,'free');
% dyn(1) = aDArrayBnd(label,fun_array,ind_array,dynParams1,'free');


%Orientation relaxation
label = 'Orientation_rel';
oPara = @(T1,t2,T3,p) (1/9).*exp(-T1./(3.*p.tau_o)).*(1+4/5.*exp(-t2./p.tau_o)).*exp(-T3./(3*p.tau_o));
oPerp = @(T1,t2,T3,p) (1/9).*exp(-T1./(3.*p.tau_o)).*(1-2/5.*exp(-t2./p.tau_o)).*exp(-T3./(3*p.tau_o));
oCrossed = @(T1,t2,T3,p) 1/15.*exp(-T1./(3.*p.tau_o)).*exp(-t2./p.tau_o).*exp(-T3./(3*p.tau_o));
oMagic = @(T1,t2,T3,p) 1/9.*exp(-T1./(3.*p.tau_o)).*exp(-T3./(3*p.tau_o));%need to checkprefactors
fun_array = {oPara}; %this is the important line that sets it as parallel!!!
ind_array = {[1:32]};  %says which feynman pathways
dynParams2 = fitParamBnd('tau_o',2.8,0.01,900,'');
dyn(2) = aDArrayBnd(label,fun_array,ind_array,dynParams2,'free');

lsfParams(1) = fitParamBnd('Delta1_cm',5.1,0.001,50,''); %for biexp 2.4
lsfParams(2) = fitParamBnd('tau1',2,0.001,50,''); %for biexp 0.6
lsfParams(3) = fitParamBnd('Delta2_cm',4.2,0.001,50,''); 
lsfParams(4) = fitParamBnd('tau2',22,0.001,50,'');
lsfParams(5) = fitParamBnd('Delta3_cm',3,0.00000001,50,''); 
lsfParams(6) = fitParamBnd('tau3',200,0.001,500,'');
lsfParams(7) = fitParamBnd('T2',3.2,0.001,50,'');
lsf = lsf3exp1fastBnd(lsfParams,'free');


clear aRFoptions s;
aRFoptions.dt = 0.2;
aRFoptions.n_t = 64;
aRFoptions.n_zp = 2*aRFoptions.n_t;
aRFoptions.flag_rotating_frame = true;
aRFoptions.w_01_cm = fitParamBnd('w_01_cm',2225.7,2220,2230,'fixed');
aRFoptions.dw_sb_cm = fitParamBnd('dw_sb_cm',13,10,20,'fixed');
%aRFoptions.mu01sq = fitParamBnd('mu01sq',6.21,0,25,'fixed');x
aRFoptions.mu01sq = fitParamBnd('mu01sq',0.082,0.0000001,1.5,'fixed');
aRFoptions.mu12sqRatio = fitParamBnd('mu12sqRatio',1.7,0.1,2.5,'fixed');
aRFoptions.anh_cm = fitParamBnd('anh_cm',30,0,40,'fixed');
aRFoptions.phase_deg = fitParamBnd('phase_deg',-1.6,-90,90,'fixed');
aRFoptions.damping = lsf;
aRFoptions.dyn = dyn;
aRFoptions.dE_cm = fitParamBnd('dE_cm',600,590,900,'fixed');
aRFoptions.temperature = fitParamBnd('temperature',295,290,505,'fixed');
% aRFoptions.T1_rel = fitParamBnd('T1_rel',10,1,100,'free');
% aRFoptions.tau_o = fitParamBnd('tau_o',1,0.1,500,'free');
aRFoptions.t2_array = [crop_data(1,:).t2]./1000;
aRFoptions.w1_in = crop_data(1,:).w1; 
aRFoptions.w3_in = (crop_data(1,:).w3);
aRFoptions.useParallel=false;  
aRFoptions.nboot = 50;

% make the first spectrum object instance
s(1) = aRFCO2Bnd(aRFoptions);

% now make the second spectrum object
fun_array = {oPerp}; %this makes it perpendicular
dyn(2) = aDArrayBnd(label,fun_array,ind_array,dynParams2,'free');
aRFoptions.dyn = dyn; % save as the only difference

% make second spectrum object instance
s(2) = aRFCO2Bnd(aRFoptions); 

% s(1).dataMatrix = prepareGlobalFitData(crop_data(1,:))/(1e4);
% s(2).dataMatrix = prepareGlobalFitData(crop_data(2,:))/(1e4);

m = multiMeasurement(s);


%% simulate via multiMeasurement

%parallel

m.s(1) = m.s(1).calcSpectrum(m.s(1).p0);
m.s(1).dataMatrix = prepareGlobalFitData(crop_data(1,:))/(1.5e4);

%perpendicular
m.s(2) = m.s(2).calcSpectrum(m.s(2).p0);
m.s(2).dataMatrix = prepareGlobalFitData(crop_data(2,:))/(1.5e4);

%% chi by eye?
matrixPlot2DIR(m.s(1,1).simMatrix,m.s(1,1).w1_in,m.s(1,1).w3_in,m.s(1,1).t2_array,[5 6],'height_px',100,'zlimit',0.7) %sim
matrixPlot2DIR(m.s(2).simMatrix,m.s(2).w1_in,m.s(2).w3_in,m.s(2).t2_array,[5 6],'height_px',100,'zlimit',1) %sim

%% minimize error?
m.globalFit

%% output

matrixPlot2DIR(m.s(1).simMatrix,m.s(1).w1_in,m.s(1).w3_in,m.s(1).t2_array,[5 6],'height_px',100,'zlimit',0.5); %sim
matrixPlot2DIR(m.s(2).simMatrix,m.s(2).w1_in,m.s(2).w3_in,m.s(2).t2_array,[5 6],'height_px',100,'zlimit',0.75); %sim

matrixPlot2DIR(m.s(1).dataMatrix,m.s(1).w1_in,m.s(1).w3_in,m.s(1).t2_array,[5 6],'height_px',100,'zlimit',0.5); %real
matrixPlot2DIR(m.s(2).dataMatrix,m.s(2).w1_in,m.s(2).w3_in,m.s(2).t2_array,[5 6],'height_px',100,'zlimit',1); %real
%cool this thing works for once. You just need to z-limit the spectra to
%see that they should have the same shape


%% time to get CLS values from the simMatrices?

zzzz_data = struct('w1',num2cell(1:29), 'w3',num2cell(1:29),'R',num2cell(1:29),'t2',num2cell(1:29));

for ii = 1 : 29
zzzz_data(ii).R = m.s(1).simMatrix(:,:,ii);
zzzz_data(ii).w1 = m.s(1).w1_in;
zzzz_data(ii).w3 = m.s(1).w3_in;
zzzz_data(ii).t2 = m.s(1).t2_array(ii).*1000;
end

zzxx_data = struct('w1',num2cell(1:29), 'w3',num2cell(1:29),'R',num2cell(1:29),'t2',num2cell(1:29));

for ii = 1 : 29
zzxx_data(ii).R = m.s(2).simMatrix(:,:,ii);
zzxx_data(ii).w1 = m.s(2).w1_in;
zzxx_data(ii).w3 = m.s(2).w3_in;
zzxx_data(ii).t2 = m.s(2).t2_array(ii).*1000;
end


%%
HWHM = 6.3;
pfOptions.range1 = [2225.7 - HWHM   2225.7 + HWHM];
pfOptions.range3 = [2180 2248]; 
view2DIRdata(zzzz_data(1),pfOptions.range1,pfOptions.range3);
pfOptions.fitfcn = fittype('- a1.*voigt(w,center,wg,wl) + a2.*voigt(w,center - anh,wg,wl) + c', ...
    'coeff',{'center','a1','a2','wg','wl','anh','c'},'indep',{'w'});
pfOptions.startpoint = [2225.7 0.01 0.01  5    5    33  0.01];
pfOptions.lb = [        2210   0    0     0    0    25  0   ];
pfOptions.ub = [        2240   Inf  Inf   100  100  50  1000];
pfOptions.zp_factor = 2;
pfOptions.flag_plot = 1;
pfOptions.estimateArea = 1;

d_zzzz = cropData(zzzz_data(1:end),pfOptions.range1,pfOptions.range3);
t2_array_zzzz =  [d_zzzz.t2]./1000;

%%
peakFit_zzzz = extractMaxima(d_zzzz,pfOptions);

%%
maxMatrix_zzzz = CLSMaxMatrix(peakFit_zzzz);
[CLS_zzzz,c2_zzzz,c2_std_zzzz] = fitCLS(d_zzzz,maxMatrix_zzzz,0);

%% ZZXX fitting
HWHM = 6.3;
pfOptions.range1 = [2225.7 - HWHM 2225.7 + HWHM];
pfOptions.range3 = [2180 2248]; 
view2DIRdata(zzzz_data(1),pfOptions.range1,pfOptions.range3);
pfOptions.fitfcn = fittype('- a1.*voigt(w,center,wg,wl) + a2.*voigt(w,center - anh,wg,wl) + c', ...
    'coeff',{'center','a1','a2','wg','wl','anh','c'},'indep',{'w'});
pfOptions.startpoint = [2225 0.01 0.01 5   5   33 0.01];
pfOptions.lb = [        2210 100  100  0   0   25 0   ];
pfOptions.ub = [        2240 Inf  Inf  30  30  50 1000];
pfOptions.zp_factor = 2;
pfOptions.flag_plot = 0;
pfOptions.estimateArea = 1;

d_zzxx = cropData(zzxx_data(1:end),pfOptions.range1,pfOptions.range3);
t2_array_zzxx =  [d_zzxx.t2]./1000;

%%
peakFit_zzxx = extractMaxima(d_zzxx,pfOptions);
%%
maxMatrix_zzxx = CLSMaxMatrix(peakFit_zzxx);
[CLS_zzxx,c2_zzxx,c2_std_zzxx] = fitCLS(d_zzxx,maxMatrix_zzxx,0);

%% Fitting Corr.Funct
close all

% cfOptions(1).startpoint = [0.3  3    0.05 ];
% cfOptions(1).lb =         [0    0.1  0    ];
% cfOptions(1).ub =         [1    20   1    ];
% cfOptions(1).fitfcn = fittype(@(a1,t1,c,x) ...
%     a1.*exp(-x./t1) + c, ...
%     'coeff', {'a1', 't1', 'c'}, 'indep', {'x'});
% cfOptions(1).flag_plot = 1; %0=off 1=on  

cfOptions(2).startpoint = [0.3 0.3 3    100 0.05 ];
cfOptions(2).lb =         [0   0   0.1  20  0    ];
cfOptions(2).ub =         [1   1   20   800 1    ];
cfOptions(2).fitfcn = fittype(@(a1,a2,t1,t2,c,x) ...
    a1.*exp(-x./t1) +  a2*exp(-x./t2) + c, ...
    'coeff', {'a1', 'a2', 't1','t2', 'c'}, 'indep', {'x'});
cfOptions(2).flag_plot = 1; %0=off 1=on 

cfOptions(3).startpoint = [0.2 0.2 0.2 3    20  100 ];
cfOptions(3).lb =         [0   0   0   0.1  5   50  ];
cfOptions(3).ub =         [1   1   1   5    50  Inf];
cfOptions(3).fitfcn = fittype(@(a1,a2,a3,t1,t2,t3,x) ...
      a1.*exp(-x./t1) +  a2*exp(-x./t2)+a3.*exp(-x./t3), ...
      'coeff', {'a1', 'a2','a3', 't1','t2','t3'}, 'indep', {'x'});
cfOptions(3).flag_plot = 1; %0=off 1=on

% cfOptions(4).startpoint = [0.7 0.8];
% cfOptions(4).lb = [0 0];
% cfOptions(4).ub = [2 1];
% cfOptions(4).fitfcn = fittype(@(a1,beta,x) a1.*exp(-x.^beta), ...
%     'coeff', {'a1','beta'}, 'indep',{'x'});
% cfOptions(4).flag_plot = 1;
% 
% cfOptions(5).startpoint = [0.7 50 0.8];
% cfOptions(5).lb = [0 0 0];
% cfOptions(5).ub = [2 Inf 1];
% cfOptions(5).fitfcn = fittype(@(a1,T0,beta,x) a1.*exp(-(x./T0).^beta), ...
%     'coeff', {'a1','T0', 'beta'}, 'indep',{'x'});
% cfOptions(5).flag_plot = 1;

for ii = 2:3
    corr_struct_zzzz = corrFcnFit(t2_array_zzzz,c2_zzzz,c2_std_zzzz,cfOptions(ii));
    CFFit_zzzz(ii) = corr_struct_zzzz;
end
for ii = 2:3
    corr_struct_zzxx = corrFcnFit(t2_array_zzxx,c2_zzxx,c2_std_zzxx,cfOptions(ii));
    CFFit_zzxx(ii) = corr_struct_zzxx;
end

%%

figure(21) %triexponential
  set(gcf,'color','w')
  plot(CFFit_zzzz(3).t2(:),(CFFit_zzzz(3).fitresult(CFFit_zzzz(3).t2(:)))); 
  hold on
  errorbar(CFFit_zzzz(3).t2(:),CFFit_zzzz(3).c2,CFFit_zzzz(3).c2_std,'ko'); 
  
  plot(CFFit_zzxx(3).t2(:),(CFFit_zzxx(3).fitresult(CFFit_zzxx(3).t2(:)))); 
  errorbar(CFFit_zzxx(3).t2(:),CFFit_zzxx(3).c2,CFFit_zzxx(3).c2_std,'ko');

  plot(Bmimn2oRTv2avesepcal.analysis.zzzz(3).t2(:),Bmimn2oRTv2avesepcal.analysis.zzzz(3).fitresult(Bmimn2oRTv2avesepcal.analysis.zzzz(3).t2(:)),'b');
  errorbar(Bmimn2oRTv2avesepcal.analysis.zzzz(3).t2(:),Bmimn2oRTv2avesepcal.analysis.zzzz(3).c2(:),Bmimn2oRTv2avesepcal.analysis.zzzz(3).c2_std(:),'bo');
  
  plot(Bmimn2oRTv2avesepcal.analysis.zzxx(3).t2(:),Bmimn2oRTv2avesepcal.analysis.zzxx(3).fitresult(Bmimn2oRTv2avesepcal.analysis.zzxx(3).t2(:)),'r');
  errorbar(Bmimn2oRTv2avesepcal.analysis.zzxx(3).t2(:),Bmimn2oRTv2avesepcal.analysis.zzxx(3).c2(:),Bmimn2oRTv2avesepcal.analysis.zzxx(3).c2_std(:),'ro');

  
  %% let's try and figure out how the ESA peak intensity changes as a function of time (normalized?)
  
  for ii = 1 : length(t2_array_zzzz)
      I_max_spara(ii) = (max(max(zzzz_data(ii).R(:,14))))./(max(max(zzzz_data(1).R(:,14))));
      I_max_sperp(ii) = (max(max(zzxx_data(ii).R(:,14))))./(max(max(zzzz_data(1).R(:,14))));
  
      I_max_rpara(ii) = (max(max(crop_data(1,ii).R(:,14))))./(max(max(crop_data(1,1).R(:,14))));
      I_max_rperp(ii) = (max(max(crop_data(2,ii).R(:,14))))./(max(max(crop_data(1,1).R(:,14))));
  end
  
  figure(501)
  plot(t2_array_zzzz,I_max_spara,'ro')
  hold on
  plot(t2_array_zzzz,I_max_sperp,'rx')
  plot(t2_array_zzzz,I_max_rpara,'bo')
  plot(t2_array_zzzz,I_max_rperp,'bx')
      xlabel('t_2 (ps)')
      ylabel('Normalized Intensity')
      legend({'Sim para','Sim perp','Real para','Real perp'})
      xlim([0 210])
      ylim([0 1.2])
  hold off
  
  %% let's try and figure out how the GSB/SE peak intensity changes as a function of time (normalized?)
  
  for ii = 1 : length(t2_array_zzzz)
      I_min_spara(ii) = (min(min(zzzz_data(ii).R(:,14))))./(min(min(zzzz_data(1).R(:,14))));
      I_min_sperp(ii) = (min(min(zzxx_data(ii).R(:,14))))./(min(min(zzzz_data(1).R(:,14))));
  
      I_min_rpara(ii) = (min(min(crop_data(1,ii).R(:,14))))./(min(min(crop_data(1,1).R(:,14))));
      I_min_rperp(ii) = (min(min(crop_data(2,ii).R(:,14))))./(min(min(crop_data(1,1).R(:,14))));
  end
  
  figure(503)
  plot(t2_array_zzzz,I_min_spara,'ro')
  hold on
  plot(t2_array_zzzz,I_min_sperp,'rx')
  plot(t2_array_zzzz,I_min_rpara,'bo')
  plot(t2_array_zzzz,I_min_rperp,'bx')
      xlabel('t_2 (ps)')
      ylabel('Normalized Intensity')
      legend({'Sim para','Sim perp','Real para','Real perp'})
      xlim([0 210])
      ylim([0 1.2])
  hold off
    