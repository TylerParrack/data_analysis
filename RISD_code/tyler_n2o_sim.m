
cd('C:\Users\tyler\Box Sync\Lifetime\SGR_Shared')
setup_tap_bmim;
prop;

%%

para = g.para;
perp = g.perp;

%%

dataMatrixPara = prepareGlobalFitData(para);
dataMatrixPerp = prepareGlobalFitData(perp);

%%

w1 = [para(1).w1];
 w3 = [para(1).w3];
t2_array = [para.t2];

  matrixPlot2DIR(dataMatrixPara,w1,w3,t2_array,[4 8],'height_px',100, 'zlimit',1);
  matrixPlot2DIR(dataMatrixPerp,w1,w3,t2_array,[4 8],'height_px',100, 'zlimit',1);
  
  %%
 alpha2d = (dataMatrixPara - dataMatrixPerp)./(dataMatrixPara + 2.*dataMatrixPerp);
  %%
 g.w1 = [para(1).w1];
 g.w3 = [para(1).w3];
 
 ind1 = [2200 2252];
 ind3 = [2200 2252];
 
w1_in_para = g(1).para(1).w1(g(1).para(1).w1>=ind1(1) & g(1).para(1).w1<=ind1(2));
w3_in_para = g(1).para(1).w3(g(1).para(1).w3>=ind3(1) & g(1).para(1).w3<=ind3(2));

w1 = w1_in_para;
w3 = w3_in_para;
    [W1,W3] = meshgrid(w1_in_para,w3_in_para);

ind = alpha2d<0.5&alpha2d>0;
plotme = alpha2d;
plotme(~ind)=nan;

xmin = 2200;
xmax = 2252;
ymin = 2200; %2300 incl. esa, 2330 is gsb/se only
ymax = 2252;

scans = [1 17 20 25];


for ii = 1:4
    
yaind1 = (g.w1>=xmin&g.w1<=xmax); %yet another index
yaind3 = (g.w3>=ymin&g.w3<=ymax); %yet another index
clear plotme
plotme = alpha2d;
plotme(~ind)=nan;
plotme = plotme(yaind3,yaind1,:);

x = g.w1(yaind1);
y = g.w3(yaind3);
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
title(sprintf('%2.1f ps',g.para(scans(ii)).t2));
set(gcf,'color','w')
set(gca,'TickDir','out')
set(gca,'Box','off')
xlim([2200 2252])
ylim([2200 2252])
end

set(gcf,'color','w')
set(gca,'TickDir','out')