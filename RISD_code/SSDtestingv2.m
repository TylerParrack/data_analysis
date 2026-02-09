%% EXAMPLE OF FITTING SSD DATA USING 2 CONE ANISOTROPY (C2_RISDFitWobbling2cone)!!
% see below
close all
clear all

%%
cd('C:\Users\tyler\Desktop\IR Spectra\Data\numbers\polarization')
% load('anemimV2_09162021ave.mat') %emim
load('anBmimV2_09162021ave.mat') %bmim
% load('anHmimV2_09162021ave.mat') %hmim
% load('anDdmimV2_09162021ave1.mat') %ddmim

%% set up data extract data from the structure (FULL)
% d1 = Emimn2oRTave.analysis; %emim
d1 = Bmimn2oRTv2ave.analysis; %bmim
% d1 = Hmimn2oRTv2ave.analysis; %hmim
% d1 = Ddmimn2oRTave1.analysis; %ddmim

t2 = [d1.zzzz(3).t2];
para_c2 = d1.zzzz(3).c2;
para_c2_std = d1.zzzz(3).c2_std;
perp_c2 = d1.zzxx(3).c2;
perp_c2_std = d1.zzxx(3).c2_std;

% anisomax = Emimn2oRTave.anisomax;
anisomax = Bmimn2oRTv2ave.anisomax';
% anisomax = Hmimn2oRTv2ave.anisomax;
% anisomax = Ddmimn2oRTave1.anisomax;

order = 1; %1 if perm dipole 2 if quadrupole

%% calculate the anisotropy of any pixel 
% need to use anisotropy2dTAPbiexp to create plot of taucorr as a function
% of pixel (or any function that calculates anisotropy)
g = Bmimn2oRTv2ave.g;
%     anisotropy2dTAPbiexp(g,2);

      dataMatrixPara= prepareGlobalFitData(g.para);
      dataMatrixPerp= prepareGlobalFitData(g.perp);
      uhpara=squeeze(dataMatrixPara(2,7,:)); %choose an arbitrary pixel (max tau_corr, max R, etc.)
      uhperp=squeeze(dataMatrixPerp(2,7,:)); %for this set, 5,7) is max tau_corr, (4,5) is max intensity
    figure(121),plot(t2,(uhpara-uhperp)./(uhpara+2.*uhperp))

anisopixel = ((uhpara-uhperp)./(uhpara+2.*uhperp))';     
    
% two dimensional anisotropy
alpha2d = (dataMatrixPara - dataMatrixPerp)./(dataMatrixPara + 2.*dataMatrixPerp);

close all
%% Bring in all the data and orders NOT BOOTSTRAPPING

%amplitude t_orientation1 theta_deg1 t_orientation2 theta_deg2

% opt.fxn = @C2_RISDFitWobbling2cone; %2 cone

lb =   [0.01  0.01  0.1    3   0.1  ]; %2 cone start bmim
ub =   [0.50  3     179.9  30  179.9];
p0 =   [0.45  1     30     11  60   ]; %good guess

%unweighted
SSE = @(p) sum((anisopixel-C2_RISDFitWobbling2cone(t2,order,p)).^2,'all');
%weighted
% SSEW =  @(p) sum((anisomax-C2_RISDFitWobbling2cone(t2,order,p)).^2./data_std.^2,'all');

tolfun = 1e-17;
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
fit0 = C2_RISDFitWobbling2cone(t2,order,p0);
figure(21),clf,
subplot(2,1,1)
plot(t2,anisopixel,'o')
hold on
plot(t2,fit0)
title('initial guess 3 cone')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,anisopixel,'o')
hold on
plot(t2,fit0)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')


%% unweighted
tic
[C2,C2_err] = fmincon(SSE,p0,[],[],[],[],lb,ub,[],opt);
toc

%look at final value
fitan = C2_RISDFitWobbling2cone(t2,order,C2);

figure(22),clf,
subplot(2,1,1)
plot(t2,anisopixel,'o')
hold on
plot(t2,fitan)
title('unweighted fit result 2 cone')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,anisopixel,'o')
hold on
plot(t2,fitan)
title('unweighted fit result 2 cone')
xlabel('t2 / ps')
ylabel('c2')

%cool, if this worked, you should have minimized the error of your 3
%wobbling cone fit to the anisotropy data and have a variable called 'C2'
%that has all of them and the associated error is 'C2_err'




%% LET'S DO SINGLE EXPONENTIAL SSD FIT
% should need inputs of t2, order, C2, and the initial guess for the ssd
% fit which is the form F = A1.*exp(-t2/T1) from Kramer2015

data_y = [para_c2; perp_c2];
data_std = [para_c2_std; perp_c2_std];

%Need new ub, lb, and p0 for SSDFitWobbling2cone_1exp

%     A1    T1   
ub = [1     9000]; %bmim 2 cone
lb = [0.01  0.01];
p0 = [0.6   300 ];

tolfun = 1e-17;
tolx = 1e-10;
maxfun = 1e5; %maximum number of function evaluations

%unweighted
SSD = @(p) sum((data_y-SSDFitWobbling2cone_1exp(t2,order,C2,p)).^2,'all');
%weighted
SSDW =  @(p) sum((data_y-SSDFitWobbling2cone_1exp(t2,order,C2,p)).^2./data_std.^2,'all');

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
fit0 = SSDFitWobbling2cone_1exp(t2,order,C2,p0);
figure(41),clf,
subplot(2,1,1)
plot(t2,para_c2,'x',t2,perp_c2,'o')
hold on
plot(t2,fit0)
title('initial guess 2 cone SSD')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'x',t2,perp_c2,'o')
hold on
plot(t2,fit0)
title('initial guess 2 cone SSD')
xlabel('t2 / ps')
ylabel('c2')

%% do the fmincon of the new SSD terms

tic
[pfit1,pfit_err1] = fmincon(SSD,p0,[],[],[],[],lb,ub,[],opt);
toc

%look at final value
fitssd1 = SSDFitWobbling2cone_1exp(t2,order,C2,pfit1);

figure(42),clf,
subplot(2,1,1)
plot(t2,para_c2,'x',t2,perp_c2,'o')
hold on
plot(t2,fitssd1)
title('unweighted fit result single exp')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'x',t2,perp_c2,'o')
hold on
plot(t2,fitssd1)
title('unweighted fit result single exp')
xlabel('t2 / ps')
ylabel('c2')

%% weighted (use unweighted as a guess)
tic
[pfit2,pfit_err2] = fmincon(SSDW,pfit1,[],[],[],[],lb,ub,[],opt);
toc

%look at final value
fitssd1w = SSDFitWobbling2cone_1exp(t2,order,C2,pfit2);

figure(43),clf,
subplot(2,1,1)
plot(t2,para_c2,'x',t2,perp_c2,'o')
hold on
plot(t2,fitssd1w)
title('weighted fit result single exp')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'x',t2,perp_c2,'o')
hold on
plot(t2,fitssd1w)
title('weighted fit result single exp')
xlabel('t2 / ps')
ylabel('c2')


%% LET'S DO A BIEXPONENTIAL SSD FIT
% should need inputs of t2, order, C2, and the initial guess for the ssd
% fit which is the form F = A1.*exp(-t2/T1) + A2.*exp(-t2/T2) from
% Kramer2015

data_y = [para_c2; perp_c2];
data_std = [para_c2_std; perp_c2_std];

%Need new ub, lb, and p0 for SSDFitWobbling2cone_2exp

%     A1   T1   A2    T2   
ub = [1     9000  1     9000];
lb = [0.01  0.01  0.01  0.01];
p0 = [0.1   10    0.6   500 ];

tolfun = 1e-17;
tolx = 1e-10;
maxfun = 1e5; %maximum number of function evaluations

%unweighted
SSD = @(p) sum((data_y-SSDFitWobbling2cone_2exp(t2,order,C2,p)).^2,'all');
%weighted
SSDW =  @(p) sum((data_y-SSDFitWobbling2cone_2exp(t2,order,C2,p)).^2./data_std.^2,'all');

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
fit0 = SSDFitWobbling2cone_2exp(t2,order,C2,p0);
figure(51),clf,
subplot(2,1,1)
plot(t2,para_c2,'x',t2,perp_c2,'o')
hold on
plot(t2,fit0)
title('initial guess biexp SSD')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'x',t2,perp_c2,'o')
hold on
plot(t2,fit0)
title('initial guess biexp SSD')
xlabel('t2 / ps')
ylabel('c2')

%% do the fmincon of the new SSD terms

tic
[pfit3,pfit_err3] = fmincon(SSD,p0,[],[],[],[],lb,ub,[],opt);
toc

%look at final value
fitssd2 = SSDFitWobbling2cone_2exp(t2,order,C2,pfit3);

figure(52),clf,
subplot(2,1,1)
plot(t2,para_c2,'x',t2,perp_c2,'o')
hold on
plot(t2,fitssd2)
title('unweighted fit biexp SSD')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'x',t2,perp_c2,'o')
hold on
plot(t2,fitssd2)
title('unweighted fit biexp SSD')
xlabel('t2 / ps')
ylabel('c2')

%% weighted (use unweighted as a guess)
tic
[pfit4,pfit_err4] = fmincon(SSDW,pfit3,[],[],[],[],lb,ub,[],opt);
toc

%look at final value
fitssd2w = SSDFitWobbling2cone_2exp(t2,order,C2,pfit4);

figure(53),clf,
subplot(2,1,1)
plot(t2,para_c2,'x',t2,perp_c2,'o')
hold on
plot(t2,fitssd2w)
title('weighted fit result biexp SSD')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'x',t2,perp_c2,'o')
hold on
plot(t2,fitssd2w)
title('weighted fit result biexp SSD')
xlabel('t2 / ps')
ylabel('c2')

%% TRI EXPONENTIAL SSD FIT




data_y = [para_c2; perp_c2];
data_std = [para_c2_std; perp_c2_std];

%Need new ub, lb, and p0 for SSDFitWobbling2cone_3exp

%     A1   T2   A2   T2    A3    T3
ub = [1     9000  1      9000    1      Inf];
lb = [0.01  0.01  0.01   0.01    0.01   0.01 ];
p0 = [0.1   10    0.1    100     0.5    600 ];

tolfun = 1e-17;
tolx = 1e-10;
maxfun = 1e5; %maximum number of function evaluations

%unweighted
SSD = @(p) sum((data_y-SSDFitWobbling2cone_3exp(t2,order,C2,p)).^2,'all');
%weighted
SSDW =  @(p) sum((data_y-SSDFitWobbling2cone_3exp(t2,order,C2,p)).^2./data_std.^2,'all');

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
fit3 = SSDFitWobbling2cone_3exp(t2,order,C2,p0);
figure(61),clf,
subplot(2,1,1)
plot(t2,para_c2,'x',t2,perp_c2,'o')
hold on
plot(t2,fit3)
title('initial guess triexp SSD')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'x',t2,perp_c2,'o')
hold on
plot(t2,fit3)
title('initial guess triexp SSD')
xlabel('t2 / ps')
ylabel('c2')

%% do the fmincon of the new SSD terms

tic
[pfit5,pfit_err5] = fmincon(SSD,p0,[],[],[],[],lb,ub,[],opt);
toc

%look at final value
fitssd3 = SSDFitWobbling2cone_3exp(t2,order,C2,pfit5);

figure(62),clf,
subplot(2,1,1)
plot(t2,para_c2,'x',t2,perp_c2,'o')
hold on
plot(t2,fitssd3)
title('unweighted fit triexp SSD')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'x',t2,perp_c2,'o')
hold on
plot(t2,fitssd3)
title('unweighted fit triexp SSD')
xlabel('t2 / ps')
ylabel('c2')

%% weighted (use unweighted as a guess)
tic
[pfit6,pfit_err6] = fmincon(SSDW,pfit5,[],[],[],[],lb,ub,[],opt);
toc

%look at final value
fitssd3w = SSDFitWobbling2cone_3exp(t2,order,C2,pfit6);

figure(63),clf,
subplot(2,1,1)
plot(t2,para_c2,'x',t2,perp_c2,'o')
hold on
plot(t2,fitssd3w)
title('weighted fit triexp SSD')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'x',t2,perp_c2,'o')
hold on
plot(t2,fitssd3w)
title('weighted fit triexp SSD')
xlabel('t2 / ps')
ylabel('c2')

