%% EXAMPLE OF BOOTSTRAPPING for anisotropy and cls
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

%%
opt.order = 1;
opt.t2 = t2;
opt.data_y = [para_c2; perp_c2];
opt.data_std = [para_c2_std; perp_c2_std];

%amplitude t_orientation1 theta_deg1 t_orientation2 theta_deg2
%t_orientation3 theta_deg3
opt.fxn = @RISDFitWobbling4; %3 cone
% opt.fxn = @RISDFitWobbling2cone; %2 cone 1 amp

% opt.lb =   [0    0    0    1   0    5    0  ]; %three cone start emim
% opt.ub =   [1.2  2    180  50  180  700  180];
% opt.p0 =   [0.7  0.1  45   1.7 62   9.4  115];

opt.lb =   [0    0.01  0.1  0.1 0.1  10   0.1]; %three cone start bmim
opt.ub =   [1.2  5     180  10  180  700  180];
opt.p0 =   [0.8  0.1   50   2   60   15   100 ];
% opt.p0 =   [0.6653    0.0104   20.1171    5.2455   33.9496   33.4148   91.8007]; %second order stark effect

% opt.lb =   [0    0.01  0.1  0.1  0.1]; %two cone start bmim
% opt.ub =   [1.2  10    180  100   180];
% opt.p0 =   [0.6  1.7   31   15   60 ]; %from aniso data
% opt.p0 =   [0.7522    0.1884   55.9687    5.1119  104.4644]; %first order SE
% opt.p0 =   [0.78    0.3   30    15  170]; %2nd order SE

% opt.lb =   [0    0    0    2   0    10   0  ]; %three cone start hmim
% opt.ub =   [1.2  2    180  10  180  700  180];
% opt.p0 =   [0.7  0.2  45   4   60   18   120];
% opt.p0 = sab.pfit;
% opt.p0(1) = 1.5*sab.pfit(1);

% opt.lb =   [0    0    0    2   0    10   0  ]; %three cone start ddmim
% opt.ub =   [1.2  2    180  20  180  700  180];
% opt.p0 =   [0.8  0.15 50   10  60   35   150];

% opt.lb =   [0   0    0    0    2   0   ]; %2cone 2 amp start
% opt.ub =   [1.2 1.2  2    180  100 180 ];
% opt.p0 =   [0.6 0.5  0.5  50   5   50  ];

opt.nboot = 50;
% opt.nboot = 200;

%make RISD curves
s = risdFit(opt);
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

sug=s.globalFit;
sug.pfit

%% look at final value
sug = sug.calcSim(sug.pfit);
fitug = sug.sim;

figure(5),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fitug)
title('unweighted fit result')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
errorbar(t2,para_c2,para_c2_std,'o')
errorbar(t2,perp_c2,perp_c2_std,'x')
plot(t2,fitug)
title('unweighted fit result')
xlabel('t2 / ps')
ylabel('c2')


%% weighted (use unweighted as a guess)
swg.p0=sug.pfit;
swg=s.globalFitW;
swg.pfit
%% look at final value
swg = swg.calcSim(swg.pfit);

%look at final value
fitwg = swg.sim;

figure(6),clf,
subplot(2,1,1)
% plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
errorbar(t2,para_c2,para_c2_std,'o')
errorbar(t2,perp_c2,perp_c2_std,'x')
plot(t2,fitwg)
title('weighted fit result')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
errorbar(t2,para_c2,para_c2_std,'o')
errorbar(t2,perp_c2,perp_c2_std,'x')
plot(t2,fitwg)
title('weighted fit result')
xlabel('t2 / ps')
ylabel('c2')

%% bootstrap -- note I am sometimes getting NaN -- I don't know why 
sb=swg.globalFitBootstrap;
% sb=sug.globalFitBootstrap; %need this for DdMIM b/c weighted is NaN
%% look at final value
sb = sb.calcSim(sb.pfit);
fitb = sb.sim;

figure(7),clf,
subplot(2,1,1)
plot(t2,para_c2,'o',t2,perp_c2,'x')
hold on
plot(t2,fitb)
title('bootstrap fit result')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,para_c2,'o',t2,perp_c2,'x')
hold on
 errorbar(t2,para_c2,para_c2_std,'o')
 errorbar(t2,perp_c2,perp_c2_std,'x')
plot(t2,fitb)
title('bootstrap fit result')
xlabel('t2 / ps')
ylabel('c2')

%% look at pboot
mean(sb.pboot,1,'omitnan')
2.*std(sb.pboot,1,'omitnan') %2 sigma

%% LETS DO IT FOR THE ANISOTROPY BABY

opt.order = 1;
opt.t2 = t2;
opt.data_y = anisomax;

%amplitude t_orientation1 theta_deg1 t_orientation2 theta_deg2
%t_orientation3 theta_deg3
opt.fxn = @C2_RISDFitWobbling4; %3 cone
% opt.fxn = @C2_RISDFitWobbling2cone; %2 cone 1 amp

% opt.lb =   [0    0    0    1   0    5    0  ]; %three cone start emim
% opt.ub =   [1    5    180  50  180  700  180];
% opt.p0 =   [0.45 2    30   11  45   82   90 ];

 opt.lb =   [0.01  0.01  0.1    1   0.1    0.1  0.1]; %three cone start bmim
 opt.ub =   [0.50  1.1   179.9  30  179.9  700  179.9];
 opt.p0 =   [0.45  0.07  31     4   50     82   90 ]; %good guess
% opt.p0 =   [0.45  0.6     50     2   60     90   90 ]; %bad guess/inertial cone

% opt.lb =   [0.01  0.01  0.1    3   0.1  ]; %2 cone start bmim
% opt.ub =   [0.50  3     179.9  100  179.9];
% opt.p0 =   [0.4   0.5   60     80  80   ]; %good guess

% opt.lb =   [0.01  0.01  0.1    5   0.1    30   0.1]; %three cone start hmim
% opt.ub =   [0.50  5     179.9  30  179.9  1e5  179.9];
% opt.p0 =   [0.45  1     30     11  45     90   110 ];
% opt.p0 = sb.pfit;
% opt.p0(1)= 1.5*sb.pfit(1);

% opt.lb =   [0.1   0.1  0.1  0.1 0.1  50   0.1]; %three cone start ddmim
% opt.ub =   [0.5   5   180   50  180  999  180];
% opt.p0 =   [0.45  1.5  25   10  35   90   110 ];

opt.nboot = 50;
% opt.nboot = 200;

%make RISD curves
sa = risdFit(opt);
sa = sa.calcSim(sa.p0);

%look at initial value
fit0a = sa.sim;
figure(10),clf,
subplot(2,1,1)
plot(t2,anisomax,'x')
hold on
plot(t2,fit0a)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,anisomax,'x')
hold on
plot(t2,fit0a)
title('initial guess')
xlabel('t2 / ps')
ylabel('c2')
%% do fit

sag=sa.globalFit;
sag.pfit

%% look at final value
sag = sag.calcSim(sag.pfit);
fitag = sag.sim;

figure(11),clf,
subplot(2,1,1)
plot(t2,anisomax,'x')
hold on
plot(t2,fitag)
title('unweighted fit result')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,anisomax,'x')
hold on
% errorbar(t2,para_c2,para_c2_std,'o')
% errorbar(t2,perp_c2,perp_c2_std,'x')
plot(t2,fitag)
title('unweighted fit result')
xlabel('t2 / ps')
ylabel('c2')


%% bootstrap -- note I am sometimes getting NaN -- I don't know why 
sab=sag.globalFitBootstrap;

%% look at final value
sab = sab.calcSim(sab.pfit);
fitab = sab.sim;

figure(12),clf,
subplot(2,1,1)
plot(t2,anisomax,'x')
hold on
plot(t2,fitab)
title('bootstrap fit result')
xlabel('t2 / ps')
ylabel('c2')

subplot(2,1,2)
semilogx(t2,anisomax,'x')
hold on
%  errorbar(t2,para_c2,para_c2_std,'o')
%  errorbar(t2,perp_c2,perp_c2_std,'x')
plot(t2,fitab)
title('bootstrap fit result')
xlabel('t2 / ps')
ylabel('c2')

%% look at pboot
mean(sab.pboot,1,'omitnan')
2.*std(sab.pboot,1,'omitnan') %2 sigma

%% what does the normalized data look like?

figure(100),clf,
subplot(2,1,1)
plot(t2,(anisomax./(anisomax(1))),'bx',t2,(para_c2./(para_c2(1))),'ro',t2,(perp_c2./(perp_c2(1))),'go')
hold on
title('comparing normalized data')
xlabel('t2 / ps');
ylabel('c2');
plot(t2,(fitab./(fitab(1))),'b',t2,(fitb(1,:)./(fitb(1,1))),'r',t2,(fitb(2,:)./fitb(2,1)),'g')
% legend('anisotropy','parallel','perpendicular','anisofit','parallel fit','perpfit');
hold off

subplot(2,1,2)

semilogx(t2,(anisomax./(anisomax(1))),'bx',t2,(para_c2./(para_c2(1))),'ro',t2,(perp_c2./(perp_c2(1))),'go')
hold on
semilogx(t2,(fitab./(fitab(1))),'b',t2,(fitb(1,:)./(fitb(1,1))),'r',t2,(fitb(2,:)./fitb(2,1)),'g')
title('comparing normalized data')
xlabel('t2 / ps');
ylabel('c2');
hold off

%% look at the histograms

figure(199)
histogram(sb.pboot(:,1),10)
hold on
histogram(sab.pboot(:,1),30)
title('amplitudes')
legend('CLS','Aniso')
hold off

figure(200)
histogram(sb.pboot(:,2),5)
hold on
histogram(sab.pboot(:,2),50)
title('Cone 1 Time (ps)')
legend('CLS','Aniso')
hold off

figure(201)
histogram(sb.pboot(:,3),10)
hold on
histogram(sab.pboot(:,3),30)
title('Cone 1 Angle (degrees)')
legend('CLS','Aniso')
hold off

figure(202)
histogram(sb.pboot(:,4),10)
hold on
histogram(sab.pboot(:,4),30)
title('Cone 2 Time (ps)')
legend('CLS','Aniso')
hold off

figure(203)
histogram(sb.pboot(:,5),15)
hold on
histogram(sab.pboot(:,5),50)
title('Cone 2 Angle (degrees)')
legend('CLS','Aniso')
hold off

figure(204)
histogram(sb.pboot(:,6),5)
hold on
histogram(sab.pboot(:,6),50)
title('Cone 3 Time (ps)')
legend('CLS','Aniso')
hold off

figure(205)
histogram(sb.pboot(:,7),10)
hold on
histogram(sab.pboot(:,7),70)
title('Cone 3 Angle (degrees)')
legend('CLS','Aniso')
hold off