

%
% plots
%
figure(734),clf,my2dPlot(opt.w1,opt.w3,g(1).para(1).R,'pumpprobe',false)
%figure(735),clf,my2dPlot(opt.w1,opt.w3,g(2).para(1).R,'pumpprobe',false)
figure(736),clf,my2dPlot(opt.w1,opt.w3,g_tot.para(1).R,'pumpprobe',false)

figure(744),clf,my2dPlot(opt.w1,opt.w3,g(1).para(end).R,'pumpprobe',false)
%figure(745),clf,my2dPlot(opt.w1,opt.w3,g(2).para(end).R,'pumpprobe',false)
figure(746),clf,my2dPlot(opt.w1,opt.w3,g_tot.para(end).R,'pumpprobe',false)

%% para tot
for ii = 1:length(g_tot.para)
    figure(741)
    if ii~=1,drawnow,pause(.5),end
    clf
    my2dPlot(opt.w1,opt.w3,g_tot.para(ii).R,'pumpprobe',false)
end
%% perp tot
for ii = 1:length(g_tot.perp)
    figure(741)
    if ii~=1,drawnow,pause(.5),end
    clf
    my2dPlot(opt.w1,opt.w3,g_tot.perp(ii).R,'pumpprobe',false)
end
