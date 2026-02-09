

%
% plots
%
% cd('~/Box/SGRLAB RESEARCH/Polarizatiion Control Data/GAUSS_MODEL')
% for ii = [1 7 16 24 32]
% figure(ii),clf,my2dPlot(opt.w1,opt.w3,g(1).para(ii).R,'pumpprobe',false)
% print(figure(ii),'-depsc',sprintf('para_%2.0f_fs',(g(1).para(ii).t2*1000)))
% end
% %%
% cd('~/Box/SGRLAB RESEARCH/Polarizatiion Control Data/GAUSS_MODEL')
% for ii = [1 7 16 24 32]
% figure(ii),clf,my2dPlot(opt.w1,opt.w3,g(1).perp(ii).R,'pumpprobe',false)
% print(figure(ii),'-depsc',sprintf('perp_%2.0f_fs',(g(1).perp(ii).t2*1000)))
% end

%%
figure(734),clf,my2dPlot(opt.w1,opt.w3,g(1).para(1).R,'pumpprobe',false)
%figure(735),clf,my2dPlot(opt.w1,opt.w3,g(2).para(1).R,'pumpprobe',false)
%figure(736),clf,my2dPlot(opt.w1,opt.w3,g_tot.para(1).R,'pumpprobe',false)

% figure(78),clf,my2dPlot(opt.w1,opt.w3,g(1).para(6).R,'pumpprobe',false)
% figure(79),clf,my2dPlot(opt.w1,opt.w3,g(1).para(16).R,'pumpprobe',false)
% figure(78),clf,my2dPlot(opt.w1,opt.w3,g(1).para(end-6).R,'pumpprobe',false)

figure(744),clf,my2dPlot(opt.w1,opt.w3,g(1).para(end).R,'pumpprobe',false)
%figure(745),clf,my2dPlot(opt.w1,opt.w3,g(2).para(end).R,'pumpprobe',false)
%figure(746),clf,my2dPlot(opt.w1,opt.w3,g_tot.para(end).R,'pumpprobe',false)

%% para tot
% for ii = 1:length(g_tot.para)
%     figure(741)
%     if ii~=1,drawnow,pause(.5),end
%     clf
%     my2dPlot(opt.w1,opt.w3,g_tot.para(ii).R,'pumpprobe',false)
% end
% % perp tot
% for ii = 1:length(g_tot.perp)
%     figure(741)
%     if ii~=1,drawnow,pause(.5),end
%     clf
%     my2dPlot(opt.w1,opt.w3,g_tot.perp(ii).R,'pumpprobe',false)
% end
%%

ind1(1) = g.para(1).w1(1);
ind1(2) = g.para(1).w1(end);
ind3(1) = g.para(1).w3(1);
ind3(2) = g.para(1).w3(end);
%%
data = g.para;
dataMatrixPara = prepareGlobalFitData(data);
w1_in_para = data(1).w1(data(1).w1>=ind1(1) & data(1).w1<=ind1(2));
w3_in_para = data(1).w3(data(1).w3>=ind3(1) & data(1).w3<=ind3(2));

%
data = g.perp;
dataMatrixPerp = prepareGlobalFitData(data);
w1_in_perp = data(1).w1(data(1).w1>=ind1(1) & data(1).w1<=ind1(2));
w3_in_perp = data(1).w3(data(1).w3>=ind3(1) & data(1).w3<=ind3(2));
%%
%
t2_array = [data.t2];%./1000;
%
w1 = w1_in_perp;
w3 = w3_in_perp;



% two dimensional anisotropy
alpha2d = (dataMatrixPara - dataMatrixPerp)./(dataMatrixPara + 2.*dataMatrixPerp);

%
inda = alpha2d<0.5&alpha2d>0;
m = 0.01.*max(max(dataMatrixPara(:,:,end)));
indb = dataMatrixPara(:,:,end)>=m;
ind = inda&repmat(indb,1,1,size(inda,3));

plotme = alpha2d;
plotme(~ind)=nan;


figure(1),clf,

for ii = 1%:length(t2_array)
    if ii>1,pause(0.3),end
    [C,h]=contourf(w1,w3,plotme(:,:,ii));
    title(sprintf('%0.1f ps',t2_array(ii)))
    clabel(C,h);
    
    
end


