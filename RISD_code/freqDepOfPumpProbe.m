%% make new simulated data
cd('~/Box/SGR_Shared/')
%%
setup_cjk
% do propagation
prop3cone
%prop
%%
expt_list = {'para','perp'};
for ii = 1:length(expt_list)
expt = expt_list{ii}
sim.(expt) = cropData(g.(expt),[2332 2350],[2332 2350]);
end
sim.t2_array = [g.para.t2];
%%
paradM = prepareGlobalFitData(sim.para);
perpdM = prepareGlobalFitData(sim.perp);
%%
sim.paradM = paradM.*-1
sim.perpdM = perpdM.*-1
%%
pp_para = squeeze(sum(sim.paradM,2));
pp_perp = squeeze(sum(sim.perpdM,2));
%%
opt.w1 = [2332:0.5:2350]; %for fitting/CLS stuff.
w3 = opt.w1;
  figure(1),clf
hold on
    subplot(1,2,1)
    for ii = [1 17 26 32]%:length(sim.t2_array)
    pl(ii) = plot(w3,pp_para(:,ii),'-','Color',rgb('cornflowerblue'))
    hold on
    end
    ylim([-0.06 0.0005])
    set(gca,'TickDir','out')
set(gca,'Box','off')
set(gca,'FontSize',15)
    subplot(1,2,2)
    for ii = [1 17 26 32]
    ppl(ii) = plot(w3,pp_perp(:,ii),'--','Color',rgb('indianred'))
   hold on
    ylim([-0.06 0.0005])
    end

set(gca,'TickDir','out')
set(gca,'FontSize',15)

%% there is some small frequency dependence to the anisotropy
alphapp = (pp_para-pp_perp)./(pp_para+2.*pp_perp);

low_freq = 2334; %somewhere in the ESA
[~,ind_low] = min((w3-low_freq).^2);

high_freq = 2348; %somewhere in the GSB
[~,ind_high] = min((w3-high_freq).^2);

cent_freq = 2341; %somewhere in the GSB
[~,ind_cent] = min((w3-cent_freq).^2);

% see the difference in the early phase but it isn't large
figure(2),clf
plot(sim.t2_array,alphapp([ind_low ind_high ind_cent],:))
%%
%
tri = fittype( @(a1, a2, a3, t1, t2, t3, x) a1.*exp(-(x./t1))+a2.*exp(-(x./t2))+a3.*exp(-(x./t3)),...
    'coeff', {'a1',  'a2', 'a3', 't1', 't2','t3'}, 'indep', {'x'});
sp = [.2 .2 .2 1 25 75];
lb = [0 0 0 0.05 1 10];
ub = [.5 .5 .5 10 100 250];


fr=fit(sim.t2_array',alphapp(ind_low,:)',tri,'Startpoint',sp,'Lower',lb,'Upper',ub);
AnisoFit(1).fitresult = fr;
fr=fit(sim.t2_array',alphapp(ind_high,:)',tri,'Startpoint',sp,'Lower',lb,'Upper',ub);
AnisoFit(2).fitresult = fr;
fr=fit(sim.t2_array',alphapp(ind_cent,:)',tri,'Startpoint',sp,'Lower',lb,'Upper',ub);
AnisoFit(3).fitresult = fr;

AnisoFit(1).fitresult
disp('low freq')

AnisoFit(2).fitresult
disp('high freq')               

AnisoFit(3).fitresult
disp('center freq')

%%
figure(2),clf
plot(sim.t2_array,alphapp([ind_low ind_high ind_cent],:),'o'),hold on
plot(sim.t2_array,AnisoFit(1).fitresult(sim.t2_array))
plot(sim.t2_array,AnisoFit(2).fitresult(sim.t2_array))
plot(sim.t2_array,AnisoFit(3).fitresult(sim.t2_array))

set(gca,'TickDir','out')
set(gca,'Box','off')
set(gca,'FontSize',15)