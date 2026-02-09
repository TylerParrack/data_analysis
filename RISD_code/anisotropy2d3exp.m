function [ alpha2d, anisoFit2D ] = anisotropy2d3exp( g ,varargin)
%anisotropy2d Calculate 2D anisotropy maps and taus
%   Detailed explanation goes here

%cutoff is for plotting
cutoff = 0.01;

%frequency offset for 2D anisotropy cut along the diagonal
offset = 0;%15;%-30;

flag_print = 0;
%flag_plot_level = 0; %nothing
flag_plot_level = 1; %final plots
%flag_plot_level = 2; %inner loop plots

%take all freqs for now
ind1(1) = g.para(1).w1(1);
ind1(2) = g.para(1).w1(end);
ind3(1) = g.para(1).w3(1);
ind3(2) = g.para(1).w3(end);

%
correction = 1; %empirical factor to correct amplitudes

while length(varargin)>=2
    arg = varargin{1};
    val = varargin{2};
    switch lower(arg)
        case {'flag_plot','flag_plot_level'}
            flag_plot_level = val;
        case {'flag_print'}
            flag_print = val;
        case {'offset'}
            offset = val;
        otherwise
            warning(sprintf('unknown parameter %s',arg));
    end
    varargin = varargin(3:end);
end

data = g.para;
dataMatrixPara = prepareGlobalFitData(data);
w1_in_para = data(1).w1(data(1).w1>=ind1(1) & data(1).w1<=ind1(2));
w3_in_para = data(1).w3(data(1).w3>=ind3(1) & data(1).w3<=ind3(2));

%
data = g.perp;
dataMatrixPerp = prepareGlobalFitData(data).*correction;
w1_in_perp = data(1).w1(data(1).w1>=ind1(1) & data(1).w1<=ind1(2));
w3_in_perp = data(1).w3(data(1).w3>=ind3(1) & data(1).w3<=ind3(2));

%
t2_array = [data.t2];%./1000;

% % Interp para and perp to same axes
% % the perp axis is entirely within the para axis, so let's use it to
% % interpolate
w1 = w1_in_perp;
w3 = w3_in_perp;
% [w1,w3] = meshgrid(w1_in_perp,w3_in_perp);
% for ii = 1:size(dataMatrixPara,3)
%     dataMatrixPara_(:,:,ii) = interp2(w1_in_para,w3_in_para,dataMatrixPara(:,:,ii),w1,w3);
% end

% two dimensional anisotropy
alpha2d = (dataMatrixPara - dataMatrixPerp)./(dataMatrixPara + 2.*dataMatrixPerp);

%
inda = alpha2d<0.5&alpha2d>0;
m = 0.01.*max(max(dataMatrixPara(:,:,end)));
indb = dataMatrixPara(:,:,end)>=m;
ind = inda&repmat(indb,1,1,size(inda,3));
if flag_plot_level>=1
    plotme = alpha2d;
    plotme(~ind)=nan;
    figure(1),clf,
    for ii = 1:length(t2_array)
        if ii>1,pause(0.3),end
        %my2dPlot(w1,w3,plotme(:,:,ii),'pumpprobe',false)
        [C,h]=contourf(w1,w3,plotme(:,:,ii));
        title(sprintf('%0.1f ps',t2_array(ii)))
        clabel(C,h);
    end
end

anisoFit2D = struct('fitresult',[],'gof',[],'startpoint',[],'lb',[],'ub',[]);
nx=length(w1);
ny=length(w3);
tauc_ = zeros(nx,ny);
a1_= zeros(nx,ny);
a2_= zeros(nx,ny);
a3_= zeros(nx,ny);
t1_= zeros(nx,ny);
t2_= zeros(nx,ny);
t3_= zeros(nx,ny);
%
tri = fittype( @(a1, a2, a3, t1, t2, t3, x) a1.*exp(-(x./t1))+a2.*exp(-(x./t2))+a3.*exp(-(x./t3)),...
    'coeff', {'a1',  'a2', 'a3', 't1', 't2','t3'}, 'indep', {'x'});
sp = [.2 .2 .2 1 25 75];
lb = [0 0 0 0.05 1 10];
ub = [.5 .5 .5 10 100 250];

tic
disp('starting 2D anisotropy fits')
for ii = 1:size(ind,1)
    fprintf(1,'row %i / %i\n',ii,size(ind,1));
    for jj = 1:size(ind,2)
        if ind(ii,jj)==0,
            tauc_(ii,jj)=nan;
            continue
        end
        
        %        [fr,G]=fit(t2_array',squeeze(alpha2d(ii,jj,:)),bi,'Startpoint',sp,'Lower',lb,'Upper',ub,'Robust','bisquare');
        x = t2_array';
        y = squeeze(alpha2d(ii,jj,:));
        x(isnan(y))=[];
        y(isnan(y))=[];
        if length(x)<5,
            tauc_(ii,jj)=nan;
            continue,
        end
        [fr,G]=fit(x,y,tri,'Startpoint',sp,'Lower',lb,'Upper',ub);
        anisoFit2D(ii,jj).fitresult = fr;
        anisoFit2D(ii,jj).gof = G;
        anisoFit2D(ii,jj).startpoint = sp;
        anisoFit2D(ii,jj).lb = lb;
        anisoFit2D(ii,jj).ub = ub;
        tauc_(ii,jj) = (fr.a1*fr.t1 + fr.a2*fr.t2 + fr.a3*fr.t3)/0.4; %is this right?
        a1_(ii,jj) = fr.a1;
        a2_(ii,jj) = fr.a2;
        a3_(ii,jj) = fr.a3;
        t1_(ii,jj) = fr.t1;
        t2_(ii,jj) = fr.t2;
        t3_(ii,jj) = fr.t3;
        
        if flag_plot_level>=2
            if ii==jj
                figure
                plot(x,y,'o',x,fr(x))
                set(gca,'Ylim',[-0.05 0.45]);
                title(sprintf('(%i,%i) (%f cm-1, %f cm-1',ii,jj,w1(ii),w3(jj)))
                drawnow
                pause(0.3)
            end
        end
    end
end
toc

if flag_plot_level
    clear plotme
    % m = abs(min(min(dataMatrixPara_(:,:,1))));
    % %ind = abs(dataMatrixPara_(:,:,1))>cutoff*m;
    % ind_gsb_2d = -dataMatrixPara_(:,:,1)>cutoff*m;
    % ind_esa_2d = dataMatrixPara_(:,:,1)>cutoff*m;
    %
    % ind = ind_gsb_2d | ind_esa_2d;
    
    m = abs(max(max(dataMatrixPara(:,:,end))));
    ind = abs(dataMatrixPara(:,:,end))>cutoff*m;
    
    %
    plot_ind = ind;
    figure(10),clf
    plotme = tauc_;
    plotme(~plot_ind)=nan;
    %my2dPlot(w1,w3,plotme)
    contourf(w1,w3,plotme)
    title('tau_c');
    colorbar
    
    figure(11),clf
    plotme = a1_;
    plotme(~plot_ind)=nan;
    %my2dPlot(w1,w3,plotme)
    contourf(w1,w3,plotme)
    colorbar
    title('a1');
    
    figure(12),clf
    plotme = a2_;
    plotme(~plot_ind)=nan;
    %my2dPlot(w1,w3,plotme)
    contourf(w1,w3,plotme)
    colorbar
    title('a2');
    
    figure(17);clf
    plotme = a3_;
    plotme(~plot_ind)=nan;
    %my2dPlot(w1,w3,plotme)
    contourf(w1,w3,plotme)
    colorbar
    title('a3');
    
    figure(13),clf
    plotme = t1_;
    plotme(~plot_ind)=nan;
    %my2dPlot(w1,w3,plotme)
    contourf(w1,w3,plotme)
    colorbar
    title('t1');
    
    figure(14),clf
    plotme = t2_;
    plotme(~plot_ind)=nan;
    %my2dPlot(w1,w3,plotme)
    contourf(w1,w3,plotme)
    colorbar
    title('t2');
    
    figure(16),clf
    plotme = t3_;
    plotme(~plot_ind)=nan;
    %my2dPlot(w1,w3,plotme)
    contourf(w1,w3,plotme)
    colorbar
    title('t3');
end


range1 = [2020 2090]; %range hardcoded?

ind_a = find(w1>=range1(1)&w1<=range1(2));
ind_b = zeros(size(ind_a));
for ii = 1:length(ind_a)
    [~,ind_b(ii)] = min((w3-w1(ind_a(ii))-offset).^2);
end

for ii = 1:length(ind_a)
    fprintf(1,'%f %f\n',w1(ind_a(ii)),w3(ind_b(ii)));
end
fprintf(1,'\n');

%
dyn = zeros(length(ind_a),length(t2_array));
tauc__ = zeros(1,length(ind_a)).*nan;
w1__ = zeros(1,length(ind_a)).*nan;
for ii = 1:length(ind_a)
    if ind(ind_b(ii),ind_a(ii))==0,continue,end
    dyn(ii,:) = squeeze(alpha2d(ind_b(ii),ind_a(ii),:));
    fprintf(1,'w1,w3= %f %f \t',w1(ind_a(ii)),w3(ind_b(ii)));
    fprintf(1,'tauc = %f\n',tauc_(ind_b(ii),ind_a(ii)));
    tauc__(ii) = tauc_(ind_b(ii),ind_a(ii));
    w1__(ii) = w1(ind_a(ii));
end

if flag_plot_level
    figure(19)
    plot(w1__,tauc__,'o')
    set(gca,'TickDir','out','Box','off')
    if flag_print
        set(gcf,'PaperUnits','centimeters','PaperPosition',[5.0 5.0 7.5 5.0])
        print(19,'-depsc','sgr_2d_anisotropy_cut.eps')
    end
end
end

