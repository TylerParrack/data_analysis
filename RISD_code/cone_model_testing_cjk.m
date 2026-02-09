%conemodeltesting
%%
load('~/Box/CJ_Kelsheimer/CJK_GRADUATE_RESEARCH/Polarizatiion Control Data/emim_analysis2.mat')
%% set up data extract data from the structure (FULL)
d = Im_anal;
t2 = [d.zzzz.CFFit(1).t2];
para_c2 = d.zzzz.c2;
para_c2_std = d.zzzz.c2_std;
perp_c2 = d.zzxx.c2;
perp_c2_std = d.zzxx.c2_std;
clear opt
%%


%1cone
%%
opt.order = 2;
opt.t2 = t2;
opt.data_y = [para_c2; perp_c2];
opt.data_std = [para_c2_std; perp_c2_std];

%amplitude t_orientation1 theta_deg1 t_orientation2 theta_deg2
opt.fxn = @RISDFitWobbling3;
% opt.lb =   [0 0 0.1 0 0.1 0 0.1];
% opt.ub =   [1.2 50 180 100 180 500 180];
% opt.p0 = [0.7 2 40 40 40 100 100];
Params = {'a', 'tr1','theta1'}
opt.lb =   [0    0    0.1 ];
opt.ub =   [1    70   180 ];
opt.p0 =   [0.85 0.4  27];
opt.nboot = 100;

%make RISD curves
s = risdFit(opt)
s = s.calcSim(s.p0);


%look at initial value
fit0 = s.sim;
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
%% do fit
s=s.globalFit

%% look at final value
s = s.calcSim(s.pfit);
fit = s.sim;

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


%% weighted (use unweighted as a guess)
s.p0=s.pfit;
s=s.globalFitW

%% look at final value
s = s.calcSim(s.pfit);

%look at final value
fit = s.sim;


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

%% bootstrap -- note I am sometimes getting NaN -- I don't know why 
s=s.globalFitBootstrap

%% look at final value
s = s.calcSim(s.pfit);
fit = s.sim;

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

%% look at pboot
bfit = mean(s.pboot,1,'omitnan')
bfit_std = 2*std(s.pboot,1,'omitnan') %2 sigma
%%
figure(2343);clf
for ii = 1:length(s.p0)
subplot(2, 4, ii)
hist(s.pboot(:,ii))
title(sprintf('%s = %2.3f, std = %2.3f', Params{ii}, bfit(ii), bfit_std(ii)))
end
%%


%2cone
%%
opt.order = 2;
opt.t2 = t2;
opt.data_y = [para_c2; perp_c2];
opt.data_std = [para_c2_std; perp_c2_std];

%amplitude t_orientation1 theta_deg1 t_orientation2 theta_deg2
opt.fxn = @RISDFitWobbling2cone;
% opt.lb =   [0 0 0.1 0 0.1 0 0.1];
% opt.ub =   [1.2 50 180 100 180 500 180];
% opt.p0 = [0.7 2 40 40 40 100 100];
Params = {'a', 'tr1','theta1','tr2','theta2'}
opt.lb =   [0    0    0.1    0  0.1];
opt.ub =   [1    5   180    100  180];
opt.p0 =   [0.85 0.4  27    80   40];
opt.nboot = 100;

%make RISD curves
s = risdFit(opt)
s = s.calcSim(s.p0);


%look at initial value
fit0 = s.sim;
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
%% do fit
s=s.globalFit

%% look at final value
s = s.calcSim(s.pfit);
fit = s.sim;

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


%% weighted (use unweighted as a guess)
s.p0=s.pfit;
s=s.globalFitW

%% look at final value
s = s.calcSim(s.pfit);

%look at final value
fit = s.sim;


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

%% bootstrap -- note I am sometimes getting NaN -- I don't know why 
s=s.globalFitBootstrap

%% look at final value
s = s.calcSim(s.pfit);
fit = s.sim;

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

%% look at pboot
bfit = mean(s.pboot,1,'omitnan')
bfit_std = 2*std(s.pboot,1,'omitnan') %2 sigma
%%
figure(2343);clf
for ii = 1:length(s.p0)
subplot(2, 4, ii)
hist(s.pboot(:,ii))
title(sprintf('%s = %2.3f, std = %2.3f', Params{ii}, bfit(ii), bfit_std(ii)))
end
%%

%2cone2amp
%%
opt.order = 2;
opt.t2 = t2;
opt.data_y = [para_c2; perp_c2];
opt.data_std = [para_c2_std; perp_c2_std];

%amplitude t_orientation1 theta_deg1 t_orientation2 theta_deg2
opt.fxn = @RISDFitWobbling2cone2amp;
% opt.lb =   [0 0 0.1 0 0.1 0 0.1];
% opt.ub =   [1.2 50 180 100 180 500 180];
% opt.p0 = [0.7 2 40 40 40 100 100];
Params = {'a1','a2', 'tr1','theta1','tr2','theta2'}
opt.lb =   [0  0  0    0.1    0  0.1];
opt.ub =   [1   1 50   180    200  180];
opt.p0 =   [0.75 0.65 8  23    98   60];
opt.nboot = 100;

%make RISD curves
s = risdFit(opt)
s = s.calcSim(s.p0);


%look at initial value
fit0 = s.sim;
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
%% do fit
s=s.globalFit

%% look at final value
s = s.calcSim(s.pfit);
fit = s.sim;

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


%% weighted (use unweighted as a guess)
s.p0=s.pfit;
s=s.globalFitW

%% look at final value
s = s.calcSim(s.pfit);

%look at final value
fit = s.sim;


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

%% bootstrap -- note I am sometimes getting NaN -- I don't know why 
s=s.globalFitBootstrap

%% look at final value
s = s.calcSim(s.pfit);
fit = s.sim;

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

%% look at pboot
bfit = mean(s.pboot,1,'omitnan')
bfit_std = 2*std(s.pboot,1,'omitnan') %2 sigma
%%
figure(2343);clf
for ii = 1:length(s.p0)
subplot(2, 4, ii)
hist(s.pboot(:,ii))
title(sprintf('%s = %2.3f, std = %2.3f', Params{ii}, bfit(ii), bfit_std(ii)))
end
%%


%3cone
%%
opt.order = 2;
opt.t2 = t2;
opt.data_y = [para_c2; perp_c2];
opt.data_std = [para_c2_std; perp_c2_std];

%amplitude t_orientation1 theta_deg1 t_orientation2 theta_deg2
opt.fxn = @RISDFitWobbling4;
% opt.lb =   [0 0 0.1 0 0.1 0 0.1];
% opt.ub =   [1.2 50 180 100 180 500 180];
% opt.p0 = [0.7 2 40 40 40 100 100];
Params = {'a', '\tau_{r1}','\theta_1','\tau_{r2}','\theta_2','\tau_{r3}','\theta_3'};
opt.lb =   [0    0   10    0  10  0   20];
opt.ub =   [1    3   180   30  180  200 180];
opt.p0 =   [0.85 0.5  27    10   23  110 65];
opt.nboot = 100;

%make RISD curves
s = risdFit(opt)
s = s.calcSim(s.p0);


%look at initial value
fit0 = s.sim;
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
%% do fit
s=s.globalFit

%% look at final value
s = s.calcSim(s.pfit);
fit = s.sim;

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


%% weighted (use unweighted as a guess)
s.p0=s.pfit;
s=s.globalFitW

%% look at final value
s = s.calcSim(s.pfit);

%look at final value
fit = s.sim;


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

%% bootstrap -- note I am sometimes getting NaN -- I don't know why 
s=s.globalFitBootstrap

%% look at final value
s = s.calcSim(s.pfit);
fit = s.sim;

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

%% look at pboot
bfit = mean(s.pboot,1,'omitnan')
bfit_std = 2*std(s.pboot,1,'omitnan') %2 sigma
%%
figure(2343);clf
for ii = 1:length(s.p0)
subplot(2, 4, ii)
hist(s.pboot(:,ii))
title(sprintf('%s = %2.3f, std = %2.3f', Params{ii}, bfit(ii), bfit_std(ii)))
end



