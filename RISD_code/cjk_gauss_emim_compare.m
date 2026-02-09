%peak overlay plot part 3 - lets try some organization I guess. 
%% EMIM

%% 
cd('~/Box/CJ_Kelsheimer/CJK_GRADUATE_RESEARCH/Polarizatiion Control Data/')
load('emim2.mat')

%% for SGR
%load('~/Box/2017_CLF_data/Lifetime/SGR_shared/emim_analysis.mat')
%emim = Im_anal
load('emim2.mat')

%%
expt_list = {'para','perp'};
for ii = 1:length(expt_list)
expt = expt_list{ii}
im.(expt) = cropData(emim.(expt),[2332 2350],[2332 2350]);
end
%%
paradM = prepareGlobalFitData(im.para);
perpdM = prepareGlobalFitData(im.perp);
%%
im.paradM = paradM
im.perpdM = perpdM
%% Run everything above this ONCE.
%%
x = im

x.w1 = x.para(1).w1
x.w3 = x.para(1).w3
x.t2_array = [x.para.t2]./1000
%%
%     matrixPlot2DIR(x.paradM,x.w1,x.w3,x.t2_array,[4 11],'height_px',100)
%     matrixPlot2DIR(x.perpdM,x.w1,x.w3,x.t2_array,[4 11],'height_px',100)
%%
    matrixPlot2DIR(x.paradM,x.w1,x.w3,x.t2_array,[1 5],'height_px',175,...
        'displayscans',[1 17 26 32 37])
    matrixPlot2DIR(x.perpdM,x.w1,x.w3,x.t2_array,[1 5],'height_px',175,...
        'displayscans',[1 17 26 32 37])
%%
%    cd('~/Box/SGRLAB RESEARCH/Polarizatiion Control Data/')
%    print(figure(1),'-depsc','para_data_spectra2.eps')
%    print(figure(2),'-depsc','perp_data_spectra2.eps')
%%
%close all
samp = x
%% Overlay Plots

color_para=[0 0 1]; 
color_perp=[1 1 0];
alpha = 0.1;

figure(2),clf,hold on
set(gcf,'color','w')
scans = [1 17 26 32];
n_contours = 8;
n_levels = 8;

for ff = 1:length(scans)

x1 = samp.para(1).w1;
y1 = samp.para(1).w3;
z1 = samp.paradM(:,:,scans(ff));
[ca1, level_list1]= myCaxis2(z1, n_contours);

x2 = samp.perp(1).w1;
y2 = samp.perp(1).w3;
z2 = samp.perpdM(:,:,scans(ff));
[ca2, level_list2]= myCaxis2(z2, n_contours);

minz = min(z1(:));
maxz = max(z1(:));
dz = (max(z1(:))-min(z1(:)))/n_levels;
ll=[minz-dz/2:dz:maxz];

minz = min(z2(:));
maxz = max(z2(:));
dz = (max(z2(:))-min(z2(:)))/n_levels;
ll2=[minz-dz/2:dz:maxz];

for ii = 1:length(ll)
    %dummy plot
    figure(1),C = contourf(x1,y1,z1,'LevelList',ll(ii));
    disp(ii)
    x_para = C(1,1:end)
    y_para = C(2,1:end)

    %loop over curves at this level, see help contourc
    ind = find(x_para==ll(ii)); %indices
    
    for jj = 1:length(ind)
        
        this_ind = ind(jj);
        n_points = y_para(1);
        
        %extract this curve
        xplot = x_para(2:n_points+1);
        yplot = y_para(2:n_points+1);
        
        %xplot2 = x2(2:n_points+1);
        %yplot2 = y2(2:n_points+1);
        
        %trim it off the front
        x_para = x_para(n_points+2:end);
        y_para = y_para(n_points+2:end);
         
        %figure(2),hold on, fill(x,y,map(ii)*255,'FaceAlpha',.1);hold off
        figure(2),subplot(2,2,ff), hold on, fill(xplot,yplot,color_para,'FaceAlpha',alpha);hold off 
    end

    minz = min(z2(:));
    maxz = max(z2(:));
    dz = (max(z2(:))-min(z2(:)))/n_levels;
    ll2=[minz-dz/2:dz:maxz];
end
for ii = 1:length(ll2)
    figure(4),C2 = contourf(x2,y2,z2,'levellist',ll2(ii));
    disp(ii)
    x_perp = C2(1,1:end)
    y_perp = C2(2,1:end)

    ind2 = find(x_perp==ll2(ii));

for jj = 1:length(ind2)
        
        this_ind = ind2(jj);
        n_points = y_perp(1);
        
        %extract this curve
        xplot = x_perp(2:n_points+1);
        yplot = y_perp(2:n_points+1);
        
        %trim it off the front
        x_perp = x_perp(n_points+2:end);
        y_perp = y_perp(n_points+2:end);
         

        figure(2),subplot(2,2,ff), hold on, fill(xplot,yplot,color_perp,'FaceAlpha',alpha);hold off
        xlabel('\omega_1 / 2\pic');
        xlim([2335 2347])
        ylim([2335 2347])
        ylabel('\omega_3 / 2\pic');
        title(sprintf('%2.1f ps',(samp.para(scans(ff)).t2./1000)));
        set(gca,'TickDir','out')
end
end
end
%% add - 2daniso calc/plots for emim

samp.alpha2d = (samp.paradM - samp.perpdM)./(samp.paradM+2.*samp.perpdM);
   %%
ind1 = [2310 2360];
ind3 = [2290 2360];

w1_in_para = samp(1).para(1).w1(samp(1).para(1).w1>=ind1(1) & samp(1).para(1).w1<=ind1(2));
w3_in_para = samp(1).para(1).w3(samp(1).para(1).w3>=ind3(1) & samp(1).para(1).w3<=ind3(2));

w1 = w1_in_para;
w3 = w3_in_para;
    [W1,W3] = meshgrid(w1_in_para,w3_in_para);

ind = samp.alpha2d<0.5&samp.alpha2d>0;
plotme = samp.alpha2d;
plotme(~ind)=nan;

xmin = 2335;
xmax = 2347;
ymin = 2335; %2300 incl. esa, 2330 is gsb/se only
ymax = 2347;

scans = [1 17 26 32];


for ii = 1:4
    
yaind1 = (samp.w1>=xmin&samp.w1<=xmax); %yet another index
yaind3 = (samp.w3>=ymin&samp.w3<=ymax); %yet another index
clear plotme
plotme = samp.alpha2d;
plotme(~ind)=nan;
plotme = plotme(yaind3,yaind1,:);

x = samp.w1(yaind1);
y = samp.w3(yaind3);
z = plotme(:,:,scans(ii));
figure(9876);clf

set(gcf,'color','w')
set(gca,'TickDir','out')
n_contours = 15;
map=myMapRGB2(n_contours);
[ca, level_list]= myCaxis2(z, n_contours);

hold on
figure(52434),subplot(2,2,ii)

[C,h]=contourf(x,y,z,level_list);
h.LevelList = round(h.LevelList.*1000)/1000;
clabel(C,h)
colormap(map)
caxis(ca);
title(sprintf('%2.1f ps',samp.t2_array(scans(ii))))
set(gcf,'color','w')
set(gca,'TickDir','out')
set(gca,'Box','off')
xlim([2337 2345])
ylim([2337 2345])
end

set(gcf,'color','w')
set(gca,'TickDir','out')



%% SIMULATED DATA

%% make new simulatexd data
cd('~/Box/SGR_Shared/')
%%
setup_cjk
% do propagation
prop2cone2amp
%prop
%%
expt_list = {'para','perp'};
for ii = 1:length(expt_list)
expt = expt_list{ii}
sim.(expt) = cropData(g.(expt),[2332 2350],[2332 2350]);
end

%%
paradM = prepareGlobalFitData(sim.para);
perpdM = prepareGlobalFitData(sim.perp);
%%
sim.paradM = paradM.*-1
sim.perpdM = perpdM.*-1
%% only need to re-run above here if you're re-simulating data.
%%
y = sim

y.w1 = y.para(1).w1
y.w3 = y.para(1).w3
y.t2_array = [y.para.t2]
%%
%     matrixPlot2DIR(y.paradM,y.w1,y.w3,y.t2_array,[4 11],'height_px',100)
%     matrixPlot2DIR(y.perpdM,y.w1,y.w3,y.t2_array,[4 11],'height_px',100)
    
%%
 matrixPlot2DIR(y.paradM,y.w1,y.w3,y.t2_array,[1 5],'height_px',175,...
        'displayscans',[1 17 26 32 37])
    matrixPlot2DIR(y.perpdM,y.w1,y.w3,y.t2_array,[1 5],'height_px',175,...
        'displayscans',[1 17 26 32 37])
%%
   cd('~/Box/SGRLAB RESEARCH/Polarizatiion Control Data/')
   %print(figure(1),'-depsc','para_simulation_spectrasmol.eps')
   %print(figure(2),'-depsc','perp_simulation_spectrasmol.eps')
%% overlay plots

color_para=[0 0 1]; 
color_perp=[1 1 0];
alpha = 0.1;

figure(3),clf,hold on
set(gcf,'color','w')
scans = [1 17 26 32];
%scans = [1 4 7 20]
n_contours = 8;
n_levels = 8;

for ff = 1:length(scans)

x1 = sim.para(1).w1;
y1 = sim.para(1).w3;
z1 = sim.paradM(:,:,scans(ff));
[ca1, level_list1]= myCaxis2(z1, n_contours);

x2 = sim.perp(1).w1;
y2 = sim.perp(1).w3;
z2 = sim.perpdM(:,:,scans(ff));
[ca2, level_list2]= myCaxis2(z2, n_contours);

minz = min(z1(:));
maxz = max(z1(:));
dz = (max(z1(:))-min(z1(:)))/n_levels;
ll=[minz-dz/2:dz:maxz];


minz = min(z2(:));
maxz = max(z2(:));
dz = (max(z2(:))-min(z2(:)))/n_levels;
ll2=[minz-dz/2:dz:maxz];

for ii = 1:length(ll)
    %dummy plot
    figure(1),C = contourf(x1,y1,z1,'LevelList',ll(ii));
    disp(ii)
    x_para = C(1,1:end)
    y_para = C(2,1:end)

    %loop over curves at this level, see help contourc
    ind = find(x_para==ll(ii)); %indices
    
    for jj = 1:length(ind)
        
        this_ind = ind(jj);
        n_points = y_para(1);
        
        %extract this curve
        xplot = x_para(2:n_points+1);
        yplot = y_para(2:n_points+1);
        
        %trim it off the front
        x_para = x_para(n_points+2:end);
        y_para = y_para(n_points+2:end);
         
   
        figure(3),subplot(2,2,ff), hold on, fill(xplot,yplot,color_para,'FaceAlpha',alpha);hold off 
    end

    minz = min(z2(:));
    maxz = max(z2(:));
    dz = (max(z2(:))-min(z2(:)))/n_levels;
    ll2=[minz-dz/2:dz:maxz];
end
for ii = 1:length(ll2)
    figure(4),C2 = contourf(x2,y2,z2,'levellist',ll2(ii));
    disp(ii)
    x_perp = C2(1,1:end)
    y_perp = C2(2,1:end)

    ind2 = find(x_perp==ll2(ii));

for jj = 1:length(ind2)
        
        this_ind = ind2(jj);
        n_points = y_perp(1);
        
        %extract this curve
        xplot = x_perp(2:n_points+1);
        yplot = y_perp(2:n_points+1);
       
        %trim it off the front
        x_perp = x_perp(n_points+2:end);
        y_perp = y_perp(n_points+2:end);
         
        %figure(2),hold on, fill(x,y,map(ii)*255,'FaceAlpha',.1);hold off
        figure(3),subplot(2,2,ff), hold on, fill(xplot,yplot,color_perp,'FaceAlpha',alpha);hold off
        xlabel('\omega_1 / 2\pic');
         xlim([2335 2347])
        ylim([2335 2347])
        ylabel('\omega_3 / 2\pic');
        title(sprintf('%2.1f ps',(sim.para(scans(ff)).t2)));
        set(gca,'TickDir','out')
end
end
end
%%

   cd('~/Box/SGRLAB RESEARCH/Polarizatiion Control Data/')
   %print(figure(2),'-dpdf','-bestfit','overlays_data_new.pdf')
   %print(figure(3),'-dpdf','-bestfit','overlays_simulation_smol.pdf')
   %%
   sim.alpha2d = (sim.paradM - sim.perpdM)./(sim.paradM+2.*sim.perpdM);
%% 2D Aniso Plots
   ind1 = [2310 2360];
ind3 = [2290 2360];

   w1_in_para = sim(1).para(1).w1(sim(1).para(1).w1>=ind1(1) & sim(1).para(1).w1<=ind1(2));
w3_in_para = sim(1).para(1).w3(sim(1).para(1).w3>=ind3(1) & sim(1).para(1).w3<=ind3(2));

w1 = w1_in_para;
w3 = w3_in_para;
[W1,W3] = meshgrid(w1_in_para,w3_in_para);

ind = sim.alpha2d<0.5&sim.alpha2d>0;
plotme = sim.alpha2d;
plotme(~ind)=nan;

xmin = 2337;
xmax = 2345;

ymin = 2337; %2300 incl. esa, 2330 is gsb/se only
ymax = 2345;
% xmin = 2330;
% xmax = 2350;
% 
% ymin = 2330; %2300 incl. esa, 2330 is gsb/se only
% ymax = 2350;

%scans = [1 4 7 20]
scans = [1 17 26 32];

for ii = 1:4
    
yaind1 = (w1>=xmin&w1<=xmax); %yet another index
yaind3 = (w3>=ymin&w3<=ymax); %yet another index
clear plotme
plotme = sim.alpha2d;
plotme(~ind)=nan;
plotme = plotme(yaind3,yaind1,:);

x = w1(yaind1);
y = w3(yaind3);
z = plotme(:,:,scans(ii));
figure(9876);clf

set(gcf,'color','w')
set(gca,'TickDir','out')
n_contours = 15;
map=myMapRGB2(n_contours);
[ca, level_list]= myCaxis2(z, n_contours);

  hold on
figure(52433),subplot(2,2,ii)
[C,h]=contourf(x,y,z,level_list);
h.LevelList = round(h.LevelList.*1000)/1000
clabel(C,h)
colormap(map)
caxis(ca);
title(sprintf('%0.1f ps',sim.para(scans(ii)).t2))
set(gcf,'color','w')
set(gca,'TickDir','out')
xlim([2337 2345])
ylim([2337 2345])
set(gca,'Box','off')

end

set(gcf,'color','w')
set(gca,'TickDir','out')
%%
   cd('~/Box/SGRLAB RESEARCH/Polarizatiion Control Data/')
   %print(figure(52434),'-depsc','2daniso_data.eps')
%     print(figure(52433),'-depsc','2daniso_sim_smol.eps')
%%
scans = [1:42];
x = emim;
    matrixPlot2DIR_c(x.dataMatrixPara,x.w1_in_para,x.w3_in_para,x.t2_array,[6 7],'displayscans',scans,'height_px',150);
    matrixPlot2DIR_c(x.dataMatrixPerp,x.w1_in_para,x.w3_in_para,x.t2_array,[6 7],'displayscans',scans,'height_px',150);
%%
   cd('~/Box/SGRLAB RESEARCH/Polarizatiion Control Data/')
%    print(figure(1),'-depsc','all_data_emim_para.eps')
%     print(figure(2),'-depsc','all_data_emim_perp.eps')
%% Extremes

cd('~/Box/SGR_Shared/')
%%
setup_cjk
% do propagation
%prop3cone
prop
%%
expt_list = {'para','perp'};
for ii = 1:length(expt_list)
expt = expt_list{ii}
sim.(expt) = cropData(g.(expt),[2332 2350],[2332 2350]);
end
paradM = prepareGlobalFitData(sim.para);
perpdM = prepareGlobalFitData(sim.perp);
sim.paradM = paradM.*-1
sim.perpdM = perpdM.*-1
   %%
   sim.alpha2d = (sim.paradM - sim.perpdM)./(sim.paradM+2.*sim.perpdM);
%% 2D Aniso Plots
   ind1 = [2310 2360];
ind3 = [2290 2360];

   w1_in_para = sim(1).para(1).w1(sim(1).para(1).w1>=ind1(1) & sim(1).para(1).w1<=ind1(2));
w3_in_para = sim(1).para(1).w3(sim(1).para(1).w3>=ind3(1) & sim(1).para(1).w3<=ind3(2));

w1 = w1_in_para;
w3 = w3_in_para;
[W1,W3] = meshgrid(w1_in_para,w3_in_para);

ind = sim.alpha2d<0.5&sim.alpha2d>0;
plotme = sim.alpha2d;
plotme(~ind)=nan;

xmin = 2337;
xmax = 2345;

ymin = 2337; %2300 incl. esa, 2330 is gsb/se only
ymax = 2345;
% xmin = 2330;
% xmax = 2350;
% 
% ymin = 2330; %2300 incl. esa, 2330 is gsb/se only
% ymax = 2350;

scans = [1 4 7 20]
%scans = [1 17 26 32];

for ii = 1:4
    
yaind1 = (w1>=xmin&w1<=xmax); %yet another index
yaind3 = (w3>=ymin&w3<=ymax); %yet another index
clear plotme
plotme = sim.alpha2d;
plotme(~ind)=nan;
plotme = plotme(yaind3,yaind1,:);

x = w1(yaind1);
y = w3(yaind3);
z = plotme(:,:,scans(ii));
figure(9876);clf

set(gcf,'color','w')
set(gca,'TickDir','out')
n_contours = 12;
map=myMapRGB2(n_contours);
[ca, level_list]= myCaxis2(z, n_contours);

  hold on
figure(52433),subplot(2,2,ii)
[C,h]=contourf(x,y,z,level_list);
h.LevelList = round(h.LevelList.*1000)/1000
clabel(C,h)
colormap(map)
caxis(ca);
title(sprintf('%0.1f ps',sim.para(scans(ii)).t2))
set(gcf,'color','w')
set(gca,'TickDir','out')
xlim([2337 2345])
ylim([2337 2345])
set(gca,'Box','off')

end

set(gcf,'color','w')
set(gca,'TickDir','out')
%%
pp_para = squeeze(sum(sim.paradM,2));
pp_perp = squeeze(sum(sim.perpdM,2));
t2_array = [sim.para.t2];
%%
for ii = 1:length(t2_array)
    figure(1),clf
    hold on
    plot(w3,pp_para(:,ii),'b-')
    plot(w3,pp_perp(:,ii),'b--')
    title(sprintf('%0.1f ps',t2_array(ii)))
    
        pause 
end
%%
figure(1);clf
hold on
plot(t2_array,-min(pp_para))
plot(t2_array,-min(pp_perp))

alpha_pp = (pp_para - pp_perp)./(pp_para + 2*pp_perp);
figure(2343);clf
plot(t2_array,max(alpha_pp),'o')
%%
bi = fittype( @(a1, a2, t1, t2, x) a1.*exp(-(x./t1))+a2.*exp(-(x./t2)),...
    'coeff', {'a1',  'a2', 't1', 't2'}, 'indep', {'x'});
sp = [.2 .2 1 120];
lb = [0 0 0.05 1];
ub = [.5 .5 5 200];

[fr, gof]=fit(t2_array',max(alpha_pp)',bi,'Startpoint',sp,'Lower',lb,'Upper',ub);

%%
tri = fittype( @(a1, a2, a3, t1, t2, t3, x) a1.*exp(-(x./t1))+a2.*exp(-(x./t2))+a3.*exp(-(x./t3)),...
    'coeff', {'a1',  'a2', 'a3', 't1', 't2','t3'}, 'indep', {'x'});
sp = [.05 .15 .15 0.5 10 150];
lb = [0 0 0 0.05 1 10];
ub = [.5 .5 .5  5 25 200];

[fr2, gof2]=fit(t2_array',max(alpha_pp)',tri,'Startpoint',sp,'Lower',lb,'Upper',ub);

%% 
figure(2342343);clf
plot(t2_array,max(alpha_pp),'o','MarkerSize',8);
hold on
%plot(t2_array,fr(t2_array));
plot(t2_array,fr2(t2_array),'--','LineWidth',2);

xlim([-5 260])
xlabel('t_2 (ps)')
ylabel('\alpha(t)')
set(gca,'TickDir','out')
set(gca,'Box','off')
set(gcf,'Color','w')
set(gca,'FontSize',18)

