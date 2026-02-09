%% take 5 two cone two amp!
clear all
close all
cd('C:\Users\tyler\Desktop\IR Spectra\Scripts\SGR_Shared');
%%
load('LIFE006_CLS_para.mat');
load('LIFE006_CLS_perp.mat');
load('LIFE006_Aniso.mat');
%stark effect order
order = 1;

%% load clinton's anisotropy data

alpha = [Aniso_19.area];
dpara = CFFit_CLS_LIFE006_para_19C;
dperp = CFFit_CLS_LIFE006_perp_19C;
alpha = alpha(7:28);

%%

t2= [Aniso_19.t2]./1000;
t2a = t2(7:28);
t2c = dpara.t2;
para_c2 = dpara.c2;
para_c2_std = dpara.c2_std;
perp_c2 = dperp.c2;
perp_c2_std = dperp.c2_std;

%% Bring in all the data and orders NOT BOOTSTRAPPING

%amplitude t_orientation1 theta_deg1 t_orientation2 theta_deg2
%t_orientation3 theta_deg3
% opt.fxn = @C2_RISDFitWobbling4; %3 cone
%       t1   theta1   t_m     180
% lb =   [0     179.9999]; %diffusion
% ub =   [500   179.9999];
% p0 =   [50    179.9999];

lb =   [0      0.1    30      179.9999];%cone + diffusion
ub =   [100    45     900     179.9999];
p0 =   [48     32     69      179.9999];

% lb =   [0      0.05    5       179.9999];%intertial + diffusion
% ub =   [0      45      900     179.9999];
% p0 =   [0      5       45      179.9999];

% lb =   [0      0.02   1    0.1     100      179.9999];%intertial + cone + diffusion
% ub =   [0      30     100  45      900      179.9999];
% p0 =   [0      5      40   40      100      179.9999];

%unweighted
SSE = @(p) sum((alpha-C2_RISDFitWobbling2cone(t2a,order,p)).^2,'all');
%weighted
% SSEW =  @(p) sum((anisomax-C2_RISDFitWobbling4(t2,order,p)).^2./data_std.^2,'all');

tolfun = 1e-20;
tolx = 1e-10;
maxfun = 1e5; %maximum number of function evaluations

% set fit parameters (I believe based on version of matlab)
if exist('optimoptions')==2,
     opt = optimoptions('fmincon','Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
elseif exist('optimset')==2,
%    opt = optimset('Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
     opt = optimset('Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
else
     warning('Could not set parameters! Look for the right options functon for your installation.');
end

%look at initial value
fitanisoguess = C2_RISDFitWobbling2cone(t2a,order,p0);
figure(21),clf,
subplot(2,1,1)
plot(t2a,alpha,'o')
hold on
plot(t2a,fitanisoguess)
title('initial guess 3 cone')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2a,alpha,'o')
hold on
plot(t2a,fitanisoguess)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')


%% unweighted
tic
[C2,C2_err] = fmincon(SSE,p0,[],[],[],[],lb,ub,[],opt);
toc

%look at final value
fitaniso = C2_RISDFitWobbling2cone(t2a,order,C2);

figure(22),clf,
subplot(2,1,1)
plot(t2a,alpha,'o')
hold on
plot(t2a,fitaniso)
title('unweighted fit result 1 cone')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2a,alpha,'o')
hold on
plot(t2a,fitaniso)
title('unweighted fit result 1 cone')
xlabel('t2 / ps')
ylabel('c2')

%cool, if this worked, you should have minimized the error of your 3
%wobbling cone fit to the anisotropy data and have a variable called 'C2'
%that has all of them and the associated error is 'C2_err'

%% Bootstrapping anisotropy
clear opt
opt.order = 1;
opt.t2 = t2a;
opt.data_y = alpha;

 
opt.fxn = @C2_RISDFitWobbling3cone; %3 cone fit
% 
opt.lb =   [0.0   0.1   10    0.1       100    179.9999];%diffusion + 2 cone]; 
opt.ub =   [50    40    100   50        700   179.9999];
opt.p0 =   [30    10    50    15        120   179.9999];

% opt.lb =   [0.0   0     10    0       ];%inertial + cone]; 
% opt.ub =   [0.0   45    100   179.9999];
% opt.p0 =   [0.0   43    30    60      ];

% opt.lb =   [0      0      10      179.9999];%cone + diffusion
% opt.ub =   [500    70     900     179.9999];
% opt.p0 =   [70     20     52      179.9999];

% opt.lb =   [0     0];%
% opt.ub =   [500     179.9999];
% opt.p0 =   [30     30];

% opt.nboot = 50;
opt.nboot = 200;

%make RISD curves
bootstrapAnisoguess = risdFit(opt);
bootstrapAnisoguess = bootstrapAnisoguess.calcSim(bootstrapAnisoguess.p0);

%look at initial value
fitanisoBSguess = bootstrapAnisoguess.sim;
figure(80),clf,
subplot(2,1,1)
plot(t2a,alpha,'x')
hold on
plot(t2a,fitanisoBSguess)
title('initial guess 3 cone')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2a,alpha,'x')
hold on
plot(t2a,fitanisoBSguess)
title('initial guess 3 cone')
xlabel('t2 / ps')
ylabel('c2')
%% do fit

anisoGlobal=bootstrapAnisoguess.globalFit; %Simulated Anisotropy Globalfit EMIM
anisoGlobal.pfit

%% look at final value
anisoGlobal = anisoGlobal.calcSim(anisoGlobal.pfit);
fitanisoGlobal = anisoGlobal.sim;

figure(81),clf,
subplot(2,1,1)
plot(t2a,alpha,'x')
hold on
plot(t2a,fitanisoGlobal)
title('unweighted Global 3 cone')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2a,alpha,'x')
hold on
plot(t2a,fitanisoGlobal)
title('unweighted Global 3 cone')
xlabel('t2 / ps')
ylabel('c2')


%% bootstrap -- note I am sometimes getting NaN -- I don't know why 
anisoBS=anisoGlobal.globalFitBootstrap; %Simulated Anisotropy Bootstrap EMIM

%% look at final value
anisoBS = anisoBS.calcSim(anisoBS.pfit);
fitanisoBS = anisoBS.sim;

figure(82),clf,
subplot(2,1,1)
plot(t2a,alpha,'x')
hold on
plot(t2a,fitanisoBS)
title('bootstrap 2 cone result')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2a,alpha,'x')
hold on
plot(t2a,fitanisoBS)
title('bootstrap 2 cone result')
xlabel('t2 / ps')
ylabel('c2')


%% histograms
figure(191)
histogram(anisoBS.pboot(:,1),100)
title('t1')

figure(192)
histogram(anisoBS.pboot(:,2),100)
title('theta1')

figure(193)
histogram(anisoBS.pboot(:,3),100)
title('t_2')
% 
figure(194)
histogram(anisoBS.pboot(:,4),100)
title('theta_2')

figure(195)
histogram(anisoBS.pboot(:,5),40)
title('t_3')
%  
% figure(196)
% histogram(anisoBS.pboot(:,6),40)
% title('theta 3')
% 
% figure(197)
% histogram(anisoBS.pboot(:,7),40)
% title('total diffusion time')

%% LET'S DO A BIEXPONENTIAL SSD FIT
% should need inputs of t2, order, C2, and the initial guess for the ssd
% fit which is the form F = A1.*exp(-t2/T1) + A2.*exp(-t2/T2) from
% Kramer2015

 data_y = [para_c2; perp_c2];
 data_std = [para_c2_std; perp_c2_std];
 
%Need new ub, lb, and p0 for SSDFitWobbling4cone_2exp

%     A1   T1     A2    T2   
% ub = [1     10    1      50   1.0   900];
% lb = [0.01  0.01  0.01   10   0.01  20 ];
% p0 = [0.2   3     0.3    30   0.2   300];

ub = [1     10    1      300 ];
lb = [0.01  0.01  0.01   10   ];
p0 = [0.7   20    0.1    500   ];

tolfun = 1e-17;
tolx = 1e-10;
maxfun = 1e5; %maximum number of function evaluations

%unweighted
SSD = @(p) sum((data_y-SSDFitWobbling2cone_2exp(t2c,order,C2,p)).^2,'all');
%weighted
SSDW =  @(p) sum((data_y-SSDFitWobbling2cone_2exp(t2c,order,C2,p)).^2./data_std.^2,'all');

% set fit parameters (I believe based on version of matlab)
if exist('optimoptions')==2,
     opt = optimoptions('fmincon','Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
elseif exist('optimset')==2,
%    opt = optimset('Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
     opt = optimset('Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
else
     warning('Could not set parameters! Look for the right options functon for your installation.');
end

%look at initial value
fit2ssdguess = SSDFitWobbling2cone_2exp(t2c,order,C2,p0);
figure(51),clf,
subplot(2,1,1)
plot(t2c,para_c2,'x',t2c,perp_c2,'o')
hold on
plot(t2c,fit2ssdguess)
title('initial guess biexp SSD')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2c,para_c2,'x',t2c,perp_c2,'o')
hold on
plot(t2c,fit2ssdguess)
title('initial guess biexp SSD')
xlabel('t2 / ps')
ylabel('c2')

%% do the fmincon of the new SSD terms

tic
[pfit2ssdUW,pfit_err2ssdUW] = fmincon(SSD,p0,[],[],[],[],lb,ub,[],opt);
toc

%look at final value
fit2ssdUW = SSDFitWobbling2cone_2exp(t2c,order,C2,pfit2ssdUW);

figure(52),clf,
subplot(2,1,1)
plot(t2c,para_c2,'x',t2c,perp_c2,'o')
hold on
plot(t2c,fit2ssdUW)
title('unweighted fit biexp SSD')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2c,para_c2,'x',t2c,perp_c2,'o')
hold on
plot(t2c,fit2ssdUW)
title('unweighted fit biexp SSD')
xlabel('t2 / ps')
ylabel('c2')

%% weighted (use unweighted as a guess)
tic
[pfit2ssdW,pfit_err2ssdW] = fmincon(SSDW,pfit2ssdUW,[],[],[],[],lb,ub,[],opt);
toc

%look at final value
fit2ssdW = SSDFitWobbling2cone_2exp(t2c,order,C2,pfit2ssdW);

figure(53),clf,
subplot(2,1,1)
plot(t2c,para_c2,'x',t2c,perp_c2,'o')
hold on
plot(t2c,fit2ssdW)
title('weighted fit result triexp SSD')
xlabel('t2 / ps')
ylabel('c2')
hold on
errorbar(t2c,para_c2,para_c2_std,'ko')
errorbar(t2c,perp_c2,perp_c2_std,'bo')
hold off

subplot(2,1,2)
semilogx(t2c,para_c2,'x',t2c,perp_c2,'o')
hold on
plot(t2c,fit2ssdW)
title('weighted fit result triexp SSD')
xlabel('t2 / ps')
ylabel('c2')
hold on
errorbar(t2c,para_c2,para_c2_std,'ko')
errorbar(t2c,perp_c2,perp_c2_std,'bo')
hold off
