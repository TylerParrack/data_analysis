%% Example of fitting RISD to wobbling in a cone

%% load data

% load('~/Box/SGRLAB RESEARCH/Polarizatiion Control Data/emim_analysis2.mat')

%% for SGR
cd('C:\Users\tyler\OneDrive\Desktop\IR Spectra\Data\numbers\dPILdata\sepcalave')
load('dPIL_IL_0100_11062025.mat') %2D data
load('emimtf2nPPdata.mat') %PP Data (high S/N for aniso)

%% get the PP data out

t2_array_Fit = emimtf2nppData.t2;
anisoFitAve = emimtf2nppData.anisoFit;

%% need to model the anisotropy first, which should be calculated again :/
w1 = [2200 2500];
w3 = [2332 2355];
uh.para=cropData(dPIL_IL_0100sepcalAve.zzzz(1:end),w1,w3);
uh.perp=cropData(dPIL_IL_0100sepcalAve.zzxx(1:end),w1,w3);

paraBig = prepareGlobalFitData(dPIL_IL_0100sepcalAve.gBig.para);
perpBig = prepareGlobalFitData(dPIL_IL_0100sepcalAve.gBig.perp);
uhParaBig = prepareGlobalFitData(uh.para);
uhPerpBig = prepareGlobalFitData(uh.perp);

%% let's get the compressed intensity at the center by collapsing all of w1
% the center is technically 5,419 (w3,w1) but we want to average over the
% range
for ii = 1:37
    paraBigCenter(ii) = trapz(paraBig(5,:,ii));
    perpBigCenter(ii) = trapz(perpBig(5,:,ii));
    uhPara(ii) = trapz(uhParaBig(5,:,ii));
    uhPerp(ii) = trapz(uhPerpBig(5,:,ii));    
end

%%

isoSumBig = paraBigCenter + 2.*perpBigCenter;
anisoSumBig = (paraBigCenter - perpBigCenter)./isoSumBig;
isoUh = uhPara + 2.*uhPerp;
anisoUh = (uhPara-uhPerp)./isoUh;

t2 = [dPIL_IL_0100sepcalAve.zzzz.t2]./1000;

%%

figure(1)
hold on
set(gca,'XScale','log')
set(gca,'TickDir','out')
plot(t2,anisoUh,'kx','MarkerSize',8,'LineWidth',1)
plot(t2,anisoSumBig,'rx','MarkerSize',8,'LineWidth',1)
plot(t2_array_Fit,anisoFitAve,'bo','MarkerSize',6,'LineWidth',1)
ylabel('Anisotropy')
xlabel('t_2 (ps)')
ylim([0 0.4])
xlim([0.1 350])
hold off

%% let's fit the PP to the wobbling models please

data_aniso = anisoFitAve;
t2a = t2_array_Fit;
order = 2;
%we're going to start with inertial, plus two cones, plus diffusion like
%Giammanco2016
    %deg_in  t1   deg1   t2   deg2   t_m
lb = [0.1    0    0.1    0    0.1    0   ];
ub = [50     5    180    30   180    1000];
p0 = [29     1    30     10   33     55  ];

SSE = @(p) sum((data_aniso-C2_RISDFitWobbling1inertial2cone1diff(t2,order,p)).^2,'all');

tolfun = 1e-17;
tolx = 1e-10;
maxfun = 1e3; %maximum number of function evaluations

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
fit0 = RISDFitWobbling3(t2,order,p0);
figure(1),clf,
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit0)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')

%% extract data from the structure (FULL)
d = Im_anal;
para_c2 = d.zzzz.c2;
para_c2_std = d.zzzz.c2_std;
perp_c2 = d.zzxx.c2;
perp_c2_std = d.zzxx.c2_std;

%% take 2

%stark effect order
order = 2;

data_y = [para_c2; perp_c2];
data_std = [para_c2_std; perp_c2_std];

%amplitude t_orientation theta_deg
lb =   [0 0 0.1];
ub =   [1 100 180];
p0 = [0.75 10 40];

%unweighted
SSE = @(p) sum((data_y-RISDFitWobbling3(t2,order,p)).^2,'all')
%weighted
SSEW =  @(p) sum((data_y-RISDFitWobbling3(t2,order,p)).^2./data_std.^2,'all');

tolfun = 1e-17;
tolx = 1e-10;
maxfun = 1e3; %maximum number of function evaluations

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
fit0 = RISDFitWobbling3(t2,order,p0);
figure(1),clf,
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit0)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')

%% unweighted
tic
[pfit,pfit_err] = fmincon(SSE,p0,[],[],[],[],lb,ub,[],opt)
toc

%look at final value
fit = RISDFitWobbling3(t2,order,pfit);

figure(2),clf,
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('unweighted fit result')
xlabel('t2 / ps')
ylabel('c2')

%% weighted (use unweighted as a guess)
tic
[pfit,pfit_err] = fmincon(SSEW,pfit,[],[],[],[],lb,ub,[],opt)
toc

%look at final value
fit = RISDFitWobbling3(t2,order,pfit);

figure(3),clf,
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('weighted fit result')
xlabel('t2 / ps')
ylabel('c2')

%% FIRST HALF 


%% extract data from the structure

clear d t2 para_c2 para_c2_std perp_c2 perp_c2_std
%%
ind = [1:12]
d = Im_anal;
t2 = [d.zzzz.CFFit(1).t2(ind)];
para_c2 = d.zzzz.c2(ind);
para_c2_std = d.zzzz.c2_std(ind);
perp_c2 = d.zzxx.c2(ind);
perp_c2_std = d.zzxx.c2_std(ind);

%% take 2

%stark effect order
order = 2;

data_y = [para_c2; perp_c2];
data_std = [para_c2_std; perp_c2_std];

%amplitude t_orientation theta_deg
lb =   [0.5 0 0.1];
ub =   [0.9 100 180];
p0 = [0.8 1 40];
% amplitude, t_r, angle
%unweighted
SSE = @(p) sum((data_y-RISDFitWobbling3(t2,order,p)).^2,'all')
%weighted
SSEW =  @(p) sum((data_y-RISDFitWobbling3(t2,order,p)).^2./data_std.^2,'all');

tolfun = 1e-17;
tolx = 1e-10;
maxfun = 1e3; %maximum number of function evaluations

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
fit0 = RISDFitWobbling3(t2,order,p0);
figure(1),clf,
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit0)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')

%% unweighted
tic
[pfit,pfit_err] = fmincon(SSE,p0,[],[],[],[],lb,ub,[],opt)
toc

%look at final value
fit = RISDFitWobbling3(t2,order,pfit);

figure(2),clf,
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('unweighted fit result')
xlabel('t2 / ps')
ylabel('c2')

%% weighted (use unweighted as a guess)
tic
[pfit,pfit_err] = fmincon(SSEW,pfit,[],[],[],[],lb,ub,[],opt)
toc

%look at final value
fit = RISDFitWobbling3(t2,order,pfit);

figure(3),clf,
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('weighted fit result')
xlabel('t2 / ps')
ylabel('c2')

%%
%% second Half


%% extract data from the structure

clear d t2 para_c2 para_c2_std perp_c2 perp_c2_std
%%
ind = [16:39]
d = Im_anal;
t2 = [d.zzzz.CFFit(1).t2(ind)];
para_c2 = d.zzzz.c2(ind);
para_c2_std = d.zzzz.c2_std(ind);
perp_c2 = d.zzxx.c2(ind);
perp_c2_std = d.zzxx.c2_std(ind);

%% take 2

%stark effect order
order = 2;

data_y = [para_c2; perp_c2];
data_std = [para_c2_std; perp_c2_std];

%amplitude t_orientation theta_deg
lb =   [0.5 0 0.1];
ub =   [0.9 100 180];
p0 = [0.7 20 40];
% amplitude, t_r, angle
%unweighted
SSE = @(p) sum((data_y-RISDFitWobbling3(t2,order,p)).^2,'all')
%weighted
SSEW =  @(p) sum((data_y-RISDFitWobbling3(t2,order,p)).^2./data_std.^2,'all');

tolfun = 1e-17;
tolx = 1e-10;
maxfun = 1e3; %maximum number of function evaluations

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
fit0 = RISDFitWobbling3(t2,order,p0);
figure(1),clf,
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit0)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')

%% unweighted
tic
[pfit,pfit_err] = fmincon(SSE,p0,[],[],[],[],lb,ub,[],opt)
toc

%look at final value
fit = RISDFitWobbling3(t2,order,pfit);

figure(2),clf,
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('unweighted fit result')
xlabel('t2 / ps')
ylabel('c2')

%% weighted (use unweighted as a guess)
tic
[pfit,pfit_err] = fmincon(SSEW,pfit,[],[],[],[],lb,ub,[],opt)
toc

%look at final value
fit = RISDFitWobbling3(t2,order,pfit);

figure(3),clf,
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('weighted fit result')
xlabel('t2 / ps')
ylabel('c2')

%%

% a = p_in(1);
% tr1 = p_in(2);
% theta_deg1 = p_in(3);
% tr2 = p_in(4);
% theta_deg2 = p_in(5);
% tr3 = p_in(6);
% theta_deg3 = p_in(7);

%% take 2

%stark effect order
order = 2;

data_y = [para_c2; perp_c2];
data_std = [para_c2_std; perp_c2_std];

%amplitude t_orientation1 theta_deg1 t_orientation2 theta_deg2
%t_orientation3 theta_deg3
lb =   [0 0 0.1 0   0.1 0   0.1 0];
ub =   [1.2 100 180 400 180 680 180];
p0 =   [0.9 0.4 27  10  23  110 60];

%unweighted
SSE = @(p) sum((data_y-RISDFitWobbling4(t2,order,p)).^2,'all')
%weighted
SSEW =  @(p) sum((data_y-RISDFitWobbling4(t2,order,p)).^2./data_std.^2,'all');

tolfun = 1e-17;
tolx = 1e-10;
maxfun = 1e3; %maximum number of function evaluations

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
fit0 = RISDFitWobbling4(t2,order,p0);
figure(1),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit0)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit0)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')


%% unweighted
tic
[pfit,pfit_err] = fmincon(SSE,p0,[],[],[],[],lb,ub,[],opt)
toc

%look at final value
fit = RISDFitWobbling4(t2,order,pfit);

figure(2),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('unweighted fit result')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')

%% weighted (use unweighted as a guess)
tic
[pfit,pfit_err] = fmincon(SSEW,pfit,[],[],[],[],lb,ub,[],opt)
toc

%look at final value
fit = RISDFitWobbling4(t2,order,pfit);

figure(3),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
hold on
plot(t2,fit)
title('weighted fit result')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)

semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')
%%
ind = 1:24;
figure(2343);clf
plt = semilogx(t2(ind),fit(:,ind))
%se(1) = semilogx(t2,para_c2,'o')
hold on
%se(2) = semilogx(t2,perp_c2,'x')
erb(1) = errorbar(t2,para_c2,para_c2_std,'o')
erb(2) = errorbar(t2,perp_c2,perp_c2_std,'x')

%title('Three Cone RISD Fit')
xlabel('t2 / ps')
ylabel('c2')

set(gca,'TickDir','out')
set(gcf,'color','w')
set(gca,'FontSize',15)
set(gca,'Box','off')
xlim([0.15 160])
ylim([0 0.9])

plt(1).Color = [0 0.3 .9]; 
plt(2).Color = [1 0.7 0];
for ii = 1:2
erb(ii).Color = plt(ii).Color
end


%%
cd ('~/Box/SGRLAB RESEARCH/Polarizatiion Control Data/')
load('sim_fit.mat')
pf
%%
d = pf
t2 = [d.para.CFFit.t2];
para_c2 = d.para.CFFit.c2;
para_c2_std = d.para.CFFit.c2_std;
perp_c2 = d.perp.CFFit.c2;
perp_c2_std = d.perp.CFFit.c2_std;
%%
order = 2;

data_y = [para_c2; perp_c2];
data_std = [para_c2_std; perp_c2_std];

%amplitude t_orientation1 theta_deg1 t_orientation2 theta_deg2
%t_orientation3 theta_deg3
lb =   [0 0 0.1 0 0.1 0 0.1];
ub =   [1.2 50 180 100 180 500 180];
p0 = [0.6 0.5 23 4 23 110 60];

%unweighted
SSE = @(p) sum((data_y-RISDFitWobbling4(t2,order,p)).^2,'all')
%weighted
SSEW =  @(p) sum((data_y-RISDFitWobbling4(t2,order,p)).^2./data_std.^2,'all');

tolfun = 1e-17;
tolx = 1e-10;
maxfun = 1e3; %maximum number of function evaluations

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
fit0 = RISDFitWobbling4(t2,order,p0);
figure(1),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit0)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit0)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')
%%
tic
[pfit,pfit_err] = fmincon(SSE,p0,[],[],[],[],lb,ub,[],opt)
toc

%look at final value
fit = RISDFitWobbling4(t2,order,pfit);

figure(2),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('unweighted fit result')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')

%% weighted (use unweighted as a guess)
tic
[pfit,pfit_err] = fmincon(SSEW,pfit,[],[],[],[],lb,ub,[],opt)
toc

%look at final value
fit = RISDFitWobbling4(t2,order,pfit);

figure(3),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('weighted fit result')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')
%%
load('~/Box/SGRLAB RESEARCH/Polarizatiion Control Data/bmpyrr_analysis.mat')

%% extract data from the structure (FULL)
d = RR_anal;
t2 = [d.zzzz.CFFit(1).t2];
para_c2 = d.zzzz.c2;
para_c2_std = d.zzzz.c2_std;
perp_c2 = d.zzxx.c2;
perp_c2_std = d.zzxx.c2_std;
%%
order = 2;

data_y = [para_c2; perp_c2];
data_std = [para_c2_std; perp_c2_std];

%amplitude t_orientation1 theta_deg1 t_orientation2 theta_deg2
%t_orientation3 theta_deg3
lb =   [0 0 0.1 0 0.1 0 0.1];
ub =   [1.2 50 180 100 180 500 180];
p0 = [0.7 2 40 40 40 100 100];

%unweighted
SSE = @(p) sum((data_y-RISDFitWobbling4(t2,order,p)).^2,'all')
%weighted
SSEW =  @(p) sum((data_y-RISDFitWobbling4(t2,order,p)).^2./data_std.^2,'all');

tolfun = 1e-17;
tolx = 1e-10;
maxfun = 1e3; %maximum number of function evaluations

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
fit0 = RISDFitWobbling4(t2,order,p0);
figure(9),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit0)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit0)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')
%%
tic
[pfit,pfit_err] = fmincon(SSE,p0,[],[],[],[],lb,ub,[],opt)
toc

%look at final value
fit = RISDFitWobbling4(t2,order,pfit);

figure(8),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('unweighted fit result')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')

%% weighted (use unweighted as a guess)
tic
[pfit,pfit_err] = fmincon(SSEW,pfit,[],[],[],[],lb,ub,[],opt)
toc

%look at final value
fit = RISDFitWobbling4(t2,order,pfit);

figure(7),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('weighted fit result')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')
%%
load('~/Box/SGRLAB RESEARCH/Polarizatiion Control Data/empy_analysis.mat')

%% extract data from the structure (FULL)
d = PY_anal;
t2 = [d.zzzz.CFFit(1).t2];
para_c2 = d.zzzz.c2;
para_c2_std = d.zzzz.c2_std;
perp_c2 = d.zzxx.c2;
perp_c2_std = d.zzxx.c2_std;
%%
order = 2;

data_y = [para_c2; perp_c2];
data_std = [para_c2_std; perp_c2_std];

%amplitude t_orientation1 theta_deg1 t_orientation2 theta_deg2
%t_orientation3 theta_deg3
lb =   [0 0 0.1 0 0.1 0 0.1];
ub =   [1.2 50 180 100 180 500 180];
p0 = [0.7 2 40 40 40 100 100];

%unweighted
SSE = @(p) sum((data_y-RISDFitWobbling4(t2,order,p)).^2,'all')
%weighted
SSEW =  @(p) sum((data_y-RISDFitWobbling4(t2,order,p)).^2./data_std.^2,'all');

tolfun = 1e-17;
tolx = 1e-10;
maxfun = 1e3; %maximum number of function evaluations

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
fit0 = RISDFitWobbling4(t2,order,p0);
figure(4),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit0)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit0)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')
%%
tic
[pfit,pfit_err] = fmincon(SSE,p0,[],[],[],[],lb,ub,[],opt)
toc

%look at final value
fit = RISDFitWobbling4(t2,order,pfit);

figure(5),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('unweighted fit result')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
% errorbar(t2,para_c2,para_c2_std,'o')
% errorbar(t2,perp_c2,perp_c2_std,'x')
plot(t2,fit)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')

hold on
pB = plot(emim.t2_array(ind),Im_anal.zzxx.CFFit(1).fitresult(emim.t2_array(ind)),'b')

%% weighted (use unweighted as a guess)
tic
[pfit,pfit_err] = fmincon(SSEW,pfit,[],[],[],[],lb,ub,[],opt)
toc

%look at final value
fit = RISDFitWobbling4(t2,order,pfit);

figure(6),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
errorbar(t2,para_c2,para_c2_std,'o')
errorbar(t2,perp_c2,perp_c2_std,'x')
plot(t2,fit)
title('weighted fit result')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
errorbar(t2,para_c2,para_c2_std,'o')
errorbar(t2,perp_c2,perp_c2_std,'x')
plot(t2,fit)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')

%%
