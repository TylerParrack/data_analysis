%% Example of fitting RISD to wobbling in one cone, two cones, and three cones 

%% load data
clear all
close all
cd('C:\Users\tyler\Desktop\IR Spectra\Data\numbers\polarization')

%% for SGR
load('anBmimV2_09162021ave.mat')

%% extract data from the structure (FULL)
d1 = Bmimn2oRTv2ave.analysis;
t2 = [d1.zzzz(3).t2];
para_c2 = d1.zzzz(3).c2;
para_c2_std = d1.zzzz(3).c2_std;
perp_c2 = d1.zzxx(3).c2;
perp_c2_std = d1.zzxx(3).c2_std;

%% take 1 one cone!


%%
%stark effect order
% order = 1;
% 
% data_y = [para_c2; perp_c2];
% data_std = [para_c2_std; perp_c2_std];
% 
% %amplitude t_orientation theta_deg
% lb =   [0    0   0  ];
% ub =   [1    200 180];
% p0 =   [0.6  5   100];
% 
% %unweighted
% SSE = @(p) sum((data_y-RISDFitWobbling3(t2,order,p)).^2,'all');
% %weighted
% SSEW =  @(p) sum((data_y-RISDFitWobbling3(t2,order,p)).^2./data_std.^2,'all');
% 
% tolfun = 1e-17;
% tolx = 1e-10;
% maxfun = 1e3; %maximum number of function evaluations
% 
% % set fit parameters (I believe based on version of matlab)
% if exist('optimoptions')==2,
%      opt = optimoptions('fmincon','Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
% elseif exist('optimset')==2,
% %    opt = optimset('Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
%      opt = optimset('Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
% else
%      warning('Could not set parameters! Look for the right options functon for your installation.');
% end
% 
% %look at initial value
% fit0 = RISDFitWobbling3(t2,order,p0);
% figure(1),clf,
% plot(t2,para_c2,'o',t2,perp_c2,'x')
% hold on
% plot(t2,fit0)
% title('initial guess 1 cone')
% xlabel('t2 / ps')
% ylabel('c2')
% 
% %% unweighted
% tic
% [pfit1,pfit_err] = fmincon(SSE,p0,[],[],[],[],lb,ub,[],opt);
% toc
% 
% %look at final value
% fit = RISDFitWobbling3(t2,order,pfit1);
% 
% figure(2),clf,
% plot(t2,para_c2,'o',t2,perp_c2,'x')
% hold on
% plot(t2,fit)
% title('unweighted fit result 1 cone')
% xlabel('t2 / ps')
% ylabel('c2')
% 
% %% weighted (use unweighted as a guess)
% tic
% [pfit1,pfit_err] = fmincon(SSEW,pfit1,[],[],[],[],lb,ub,[],opt);
% toc
% 
% %look at final value
% fit = RISDFitWobbling3(t2,order,pfit1);
% 
% figure(3),clf,
% plot(t2,para_c2,'o',t2,perp_c2,'x')
% hold on
% plot(t2,fit)
% title('weighted fit result 1 cone')
% xlabel('t2 / ps')
% ylabel('c2')
% 

%% take 2 two cones!


%%
%stark effect order
% order = 1;
% 
% data_y = [para_c2; perp_c2];
% data_std = [para_c2_std; perp_c2_std];
% 
% %amplitude t_orientation1 theta_deg1 t_orientation2 theta_deg2
% 
% lb =   [0   0    0   1   0  ];
% ub =   [1.2 1    180 500 180];
% p0 =   [0.6 0.6  55  7  100 ];
% 
% %unweighted
% SSE = @(p) sum((data_y-RISDFitWobbling2cone(t2,order,p)).^2,'all');
% %weighted
% SSEW =  @(p) sum((data_y-RISDFitWobbling2cone(t2,order,p)).^2./data_std.^2,'all');
% 
% tolfun = 1e-17;
% tolx = 1e-10;
% maxfun = 1e4; %maximum number of function evaluations
% 
% % set fit parameters (I believe based on version of matlab)
% if exist('optimoptions')==2,
%      opt = optimoptions('fmincon','Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
% elseif exist('optimset')==2,
% %    opt = optimset('Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
%      opt = optimset('Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
% else
%      warning('Could not set parameters! Look for the right options functon for your installation.');
% end
% 
% %look at initial value
% fit0 = RISDFitWobbling2cone(t2,order,p0);
% figure(10),clf,
% subplot(2,1,1)
% plot(t2,para_c2,'o',t2,perp_c2,'x')
% hold on
% plot(t2,fit0)
% title('initial guess 2 cone')
% xlabel('t2 / ps')
% ylabel('c2')
% 
% subplot(2,1,2)
% semilogx(t2,para_c2,'o',t2,perp_c2,'x')
% hold on
% plot(t2,fit0)
% title('initial guess 2 cone')
% xlabel('t2 / ps')
% ylabel('c2')
% 
% 
% %% unweighted
% tic
% [pfit2,pfit_err] = fmincon(SSE,p0,[],[],[],[],lb,ub,[],opt);
% toc
% 
% %look at final value
% fit = RISDFitWobbling2cone(t2,order,pfit2);
% 
% figure(11),clf,
% subplot(2,1,1)
% plot(t2,para_c2,'o',t2,perp_c2,'x')
% hold on
% plot(t2,fit)
% title('unweighted fit result 2 cone')
% xlabel('t2 / ps')
% ylabel('c2')
% 
% subplot(2,1,2)
% semilogx(t2,para_c2,'o',t2,perp_c2,'x')
% hold on
% plot(t2,fit)
% title('unweighted fit result 2 cone')
% xlabel('t2 / ps')
% ylabel('c2')
% 
% %% weighted (use unweighted as a guess)
% tic
% [pfit2,pfit_err] = fmincon(SSEW,pfit2,[],[],[],[],lb,ub,[],opt);
% toc
% 
% %look at final value
% fit = RISDFitWobbling2cone(t2,order,pfit2);
% 
% figure(12),clf,
% subplot(2,1,1)
% plot(t2,para_c2,'o',t2,perp_c2,'x')
% hold on
% hold on
% plot(t2,fit)
% title('weighted fit result 2 cone')
% xlabel('t2 / ps')
% ylabel('c2')
% 
% subplot(2,1,2)
% 
% semilogx(t2,para_c2,'o',t2,perp_c2,'x')
% hold on
% plot(t2,fit)
% title('weighted fit result 2 cone')
% xlabel('t2 / ps')
% ylabel('c2')
% %%
% ind = 1:29;
% figure(200);clf
% plt = semilogx(t2(ind),fit(:,ind))
% %se(1) = semilogx(t2,para_c2,'o')
% hold on
% %se(2) = semilogx(t2,perp_c2,'x')
% erb(1) = errorbar(t2,para_c2,para_c2_std,'o');
% erb(2) = errorbar(t2,perp_c2,perp_c2_std,'x');
% 
% title('Weighted Two Cone RISD Fit')
% xlabel('t2 / ps')
% ylabel('c2')
% 
% set(gca,'TickDir','out')
% set(gcf,'color','w')
% set(gca,'FontSize',15)
% set(gca,'Box','off')
% xlim([0.15 160])
% ylim([0 0.9])
% 
% plt(1).Color = [0 0.3 .9]; 
% plt(2).Color = [1 0.7 0];
% for ii = 1:2
% erb(ii).Color = plt(ii).Color;
% end

%% take 3 three cones!

%stark effect order
order = 1;

data_y = [para_c2; perp_c2];
data_std = [para_c2_std; perp_c2_std];

%amplitude t_orientation1 theta_deg1 t_orientation2 theta_deg2
%t_orientation3 theta_deg3
lb =   [0    0    0    2   0    10  0];
ub =   [1.2  2    180  10  180 700  180];
% p0 =   [0.6  0.5  50   10  50   15  130];
% p0 =   [0.8  0.1  50   2   60   12  100]; %bootstrapping values
p0 =   [0.6 1.0  29   10.6  45  81.8  90.1];

%unweighted
SSE = @(p) sum((data_y-RISDFitWobbling4(t2,order,p)).^2,'all');
%weighted
SSEW =  @(p) sum((data_y-RISDFitWobbling4(t2,order,p)).^2./data_std.^2,'all');

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
fit0 = RISDFitWobbling4(t2,order,p0);
figure(31),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit0)
title('initial guess 3 cone')
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
[pfit3,pfit_err] = fmincon(SSE,p0,[],[],[],[],lb,ub,[],opt);
toc

%look at final value
fit = RISDFitWobbling4(t2,order,pfit3);

figure(32),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('unweighted fit result 3 cone')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('unweighted fit result 3 cone')
xlabel('t2 / ps')
ylabel('c2')

%% weighted (use unweighted as a guess)
tic
[pfit3w,pfit_errw] = fmincon(SSEW,pfit3,[],[],[],[],lb,ub,[],opt);
toc

%look at final value
fit = RISDFitWobbling4(t2,order,pfit3w);

figure(33),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
hold on
plot(t2,fit)
title('weighted fit result 3 cone')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)

semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('weighted fit result 3 cone')
xlabel('t2 / ps')
ylabel('c2')
%%
ind = 1:29;
figure(300);clf
plt = semilogx(t2(ind),fit(:,ind))
%se(1) = semilogx(t2,para_c2,'o')
hold on
%se(2) = semilogx(t2,perp_c2,'x')
erb(1) = errorbar(t2,para_c2,para_c2_std,'o');
erb(2) = errorbar(t2,perp_c2,perp_c2_std,'x');

title('Weighted Three Cone RISD Fit')
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
erb(ii).Color = plt(ii).Color;
end


%% take 4 two cone two amp!

%stark effect order
order = 1;

data_y = [para_c2; perp_c2];
data_std = [para_c2_std; perp_c2_std];

%amplitude1 amplitude2 t_orientation1 theta_deg1 t_orientation2 theta_deg2

lb =   [0   0    0    0    2   0   ];
ub =   [1.2 1.2  2    180  100 180 ];
p0 =   [0.6 0.5  0.5  50   5   50  ];

%unweighted
SSE = @(p) sum((data_y-RISDFitWobbling2cone2amp(t2,order,p)).^2,'all');
%weighted
SSEW =  @(p) sum((data_y-RISDFitWobbling2cone2amp(t2,order,p)).^2./data_std.^2,'all');

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
fit0 = RISDFitWobbling2cone2amp(t2,order,p0);
figure(41),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit0)
title('initial guess 2 cone 2 amp')
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
[pfit4,pfit_err] = fmincon(SSE,p0,[],[],[],[],lb,ub,[],opt);
toc

%look at final value
fit = RISDFitWobbling2cone2amp(t2,order,pfit4);

figure(42),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('unweighted fit result 2 cone 2 amp')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('unweighted fit result 2 cone 2 amp')
xlabel('t2 / ps')
ylabel('c2')

%% weighted (use unweighted as a guess)
tic
[pfit4,pfit_err] = fmincon(SSEW,pfit4,[],[],[],[],lb,ub,[],opt);
toc

%look at final value
fit = RISDFitWobbling2cone2amp(t2,order,pfit4);

figure(43),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
hold on
plot(t2,fit)
title('weighted fit result 2 cone 2 amp')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)

semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fit)
title('weighted fit result 2 cone 2 amp')
xlabel('t2 / ps')
ylabel('c2')
%%
ind = 1:29;
figure(400);clf
plt = semilogx(t2(ind),fit(:,ind))
%se(1) = semilogx(t2,para_c2,'o')
hold on
%se(2) = semilogx(t2,perp_c2,'x')
erb(1) = errorbar(t2,para_c2,para_c2_std,'o');
erb(2) = errorbar(t2,perp_c2,perp_c2_std,'x');

title('Weighted Two Cone Two Amp RISD Fit')
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

%% Look at potential C2? 


%% take 5 two cone two amp!

%stark effect order
order = 1;

data_y = [para_c2; perp_c2];
 
 w1= [2220 2235];
 w3= [2220 2235]; %BMIM range
 
 g.para=cropData(Bmimn2oRTv2ave.zzzz(1:end),w1,w3);
 g.perp=cropData(Bmimn2oRTv2ave.zzxx(1:end),w1,w3);
 
 dataMatrixPara = prepareGlobalFitData(g.para);
 dataMatrixPerp = prepareGlobalFitData(g.perp);
 
 alpha2d = (dataMatrixPara - dataMatrixPerp)./(dataMatrixPara + 2.*dataMatrixPerp);
 alphamax = squeeze(alpha2d(5,7,:)).';

%amplitude1 amplitude2 t_orientation1 theta_deg1 t_orientation2 theta_deg2

lb =   [0   0    0  0    3   0   ];
ub =   [1   1    3  180  100 180 ];
p0 =   [0   0    2  60   11  100  ];

%unweighted
SSE = @(p) sum((alphamax-C2_RISDFitWobbling2cone2amp(t2,order,p)).^2,'all');
%weighted
SSEW =  @(p) sum((alphamax-C2_RISDFitWobbling2cone2amp(t2,order,p)).^2./data_std.^2,'all');

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
fit0 = C2_RISDFitWobbling2cone2amp(t2,order,p0);
figure(51),clf,
subplot(2,1,1)
plot(t2,alphamax,'o')
hold on
plot(t2,fit0)
title('initial guess 2 cone 2 amp')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,alphamax,'o')
hold on
plot(t2,fit0)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')


%% unweighted
tic
[pfit5,pfit_err] = fmincon(SSE,p0,[],[],[],[],lb,ub,[],opt);
toc

%look at final value
fit = C2_RISDFitWobbling2cone2amp(t2,order,pfit5);

figure(52),clf,
subplot(2,1,1)
plot(t2,alphamax,'o')
hold on
plot(t2,fit)
title('unweighted fit result 2 cone 2 amp')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,alphamax,'o')
hold on
plot(t2,fit)
title('unweighted fit result 2 cone 2 amp')
xlabel('t2 / ps')
ylabel('c2')

%% weighted (use unweighted as a guess)
tic
[pfit5,pfit_err] = fmincon(SSEW,pfit5,[],[],[],[],lb,ub,[],opt);
toc

%look at final value
fit = C2_RISDFitWobbling2cone2amp(t2,order,pfit5);

figure(53),clf,
subplot(2,1,1)
plot(t2,alphamax(:),'o')
hold on
hold on
plot(t2,fit)
title('weighted fit result 2 cone 2 amp')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)

semilogx(t2,alphamax(:),'o')
hold on
plot(t2,fit)
title('weighted fit result 2 cone 2 amp')
xlabel('t2 / ps')
ylabel('c2')
%%
% ind = 1:29;
% figure(500);clf
% plt = semilogx(t2(ind),fit(:,ind))
% %se(1) = semilogx(t2,para_c2,'o')
% hold on
% %se(2) = semilogx(t2,perp_c2,'x')
% erb(1) = errorbar(t2,alphamax,'o');
% % erb(2) = errorbar(t2,perp_c2,perp_c2_std,'x')
% 
% title('Weighted Two Cone Two Amp Anisotropy Fit')
% xlabel('t2 / ps')
% ylabel('c2')
% 
% set(gca,'TickDir','out')
% set(gcf,'color','w')
% set(gca,'FontSize',15)
% set(gca,'Box','off')
% xlim([0.15 160])
% ylim([0 0.9])
% 
% plt(1).Color = [0 0.3 .9]; 
% for ii = 1
% erb(ii).Color = plt(ii).Color;
% end
%% take 6 anisotropy for 3 cone 1 amplitude



%%
%amplitude1 t_orientation1 theta_deg1 t_orientation2 theta_deg2
%t_orientation3 theta_deg3

lb =   [0    0.01  0    5    0    20   0  ];
ub =   [1  5     180  20   180  700  180];
p0 =   [1.3   0.071  50   2.1   58   12.5  105 ]; %weighted 3 cone fit
% p0 =   [0.45 2     30   12   58   60   105 ]; %weighted 3 cone fit

%unweighted
SSE = @(p) sum((alphamax-C2_RISDFitWobbling4(t2,order,p)).^2,'all');
%weighted
SSEW =  @(p) sum((alphamax-C2_RISDFitWobbling4(t2,order,p)).^2./data_std.^2,'all');

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
fit0 = C2_RISDFitWobbling4(t2,order,p0);
figure(61),clf,
subplot(2,1,1)
plot(t2,alphamax,'o')
hold on
plot(t2,fit0)
title('initial guess 3 cone')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,alphamax,'o')
hold on
plot(t2,fit0)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')


%% unweighted
tic
[pfit6,pfit_err] = fmincon(SSE,p0,[],[],[],[],lb,ub,[],opt);
toc

%look at final value
fit = C2_RISDFitWobbling4(t2,order,pfit6);

figure(62),clf,
subplot(2,1,1)
plot(t2,alphamax,'o')
hold on
plot(t2,fit)
title('unweighted fit result 3 cone')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,alphamax,'o')
hold on
plot(t2,fit)
title('unweighted fit result 3 cone')
xlabel('t2 / ps')
ylabel('c2')

%% weighted (use unweighted as a guess)
tic
[pfit6,pfit_err] = fmincon(SSEW,pfit6,[],[],[],[],lb,ub,[],opt);
toc

%look at final value
fit = C2_RISDFitWobbling4(t2,order,pfit6);

figure(63),clf,
subplot(2,1,1)
plot(t2,alphamax(:),'o')
hold on
hold on
plot(t2,fit)
title('weighted fit result 3 cone')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)

semilogx(t2,alphamax(:),'o')
hold on
plot(t2,fit)
title('weighted fit result 3 cone')
xlabel('t2 / ps')
ylabel('c2')