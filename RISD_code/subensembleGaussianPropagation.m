function [g_tot,g,jpd]=subensembleGaussianPropagation(subens_params,opt)

%
% calc distributions
%

%1. clean up inputs
%
n_subensembles = length(subens_params);
n_t2 = length(opt.t2_array);
w1 = opt.w1;
w3 = opt.w3;

% normalize probabilities
prob_array = [subens_params.prob]; %pull probs into an arraycd
norm = sum(prob_array); %norm is the sum of probs
prob_array = prob_array./norm; %normalize
tmp = num2cell(prob_array);% for shortcut assignment below
[subens_params.prob] = tmp{:}; %assign back


% initialize FIX FIX FIX
g = myConstructor;
g_tot = myConstructor;


[W1,W3] = meshgrid(w1,w3);

%set up terms
%R_para; %RISD functions for para perp
%R_perp; %RISD functions for para perp
%P_or_para; %amplitude from orientational response
%P_or_perp; %amplitude from orientational response
%P_ver; %amplitude for vibrational energy relaxation (T1)
%

%default to first order; look for flag for higher order
stark_effect_order = 1;
if isfield(opt,'stark_effect_order')
    stark_effect_order = opt.stark_effect_order;
end


    C = wobblingC;
    Ctot = cell(1,4);
    
    in(1).tr = subens_params.tr;
    in(1).theta_deg = subens_params.theta_deg;

   
    for l = 1:4
        %Ctot{l} = 1;
        %for ii = 1:ncones
            Ctot{l}=@(p,t)C{l}(in(1),t)
        %end
    end
    
    R = wobblingR(Ctot,stark_effect_order)

    O = wobblingO(Ctot)

oPara = O.para;
oPerp = O.perp;

R_para = R.para 
R_perp = R.perp
R_iso = R.iso

%
% comment below here
%
% %helper functions
% C1 = @(tr,x)exp(-2.*(1./(6*tr))*x);
% C2 = @(tr,x)exp(-6.*(1./(6*tr))*x);
% C3 = @(tr,x)exp(-12.*(1./(6*tr))*x);
% C4 = @(tr,x)exp(-20.*(1./(6*tr))*x);
% 
% switch stark_effect_order
%     case 1 % from Kramer2015a
% R_para = @(tr,x)(3/25)*((11.*C1(tr,x) + 4*C3(tr,x))./(1 + 0.8*C2(tr,x)));
% R_perp = @(tr,x)(3/25)*(( 7.*C1(tr,x) - 2*C3(tr,x))./(1 - 0.4*C2(tr,x)));
% R_iso = @(tr,x)C1(tr,x);
%     case 2 % from 
% R_para = @(tr,x)(1/175)*((28 + 215.*C2(tr,x) + 72*C4(tr,x))./(1 + 0.8*C2(tr,x)));
% R_perp = @(tr,x)(1/175)*((-14 + 155.*C2(tr,x) - 36*C4(tr,x))./(1 - 0.4*C2(tr,x)));
% R_iso = @(tr,x)C2(tr,x);
%     otherwise
%         error('only order 1 and 2 coded');
% end
% 
% %orientation
% oPara = @(tau_o,t2) (1/9).*(1+4/5.*exp(-t2./tau_o));
% oPerp = @(tau_o,t2) (1/9).*(1-2/5.*exp(-t2./tau_o));
% %
% to here
%

P_ver = @(T1,t)exp(-t./T1);

%2. loop over subensembles
for ii = 1:n_subensembles
    
    % pull input variables
    t_or = subens_params(ii).t_or;
    w0 = subens_params(ii).w0;
    T1 = subens_params(ii).T1;
    amp = subens_params(ii).prob;
    sigma = subens_params(ii).sigma;
    c0 = subens_params(ii).c0;
    
    % loop over times
    for jj = 1:n_t2
        t2 = opt.t2_array(jj);
        
        %corr = c0*R_para(t_or,t2); %risd ffcf
        corr = c0*R_para(subens_params(ii),t2); %risd ffcf
        jpd = gaussianJPD(W1,W3,w0,amp,sigma,corr); %gaussian approx to joint-probability density
        %para = P_ver(T1,t2).*oPara(t_or,t2).*jpd;
        para = P_ver(T1,t2).*oPara(subens_params(ii),t2).*jpd;
        
        %corr = c0*R_perp(t_or,t2); %risd ffcf
        corr = c0*R_perp(subens_params(ii),t2); %risd ffcf
        jpd = gaussianJPD(W1,W3,w0,amp,sigma,corr); %gaussian approx to joint-probability density
        %perp = P_ver(T1,t2).*oPerp(t_or,t2).*jpd;
        perp = P_ver(T1,t2).*oPerp(subens_params(ii),t2).*jpd;
        
        %store outputs
        g(ii).para(jj).R = para;
        g(ii).para(jj).t2 = t2;
        g(ii).para(jj).w1 = w1;
        g(ii).para(jj).w3 = w3;
        
        g(ii).perp(jj).R = perp;
        g(ii).perp(jj).t2 = t2;
        g(ii).perp(jj).w1 = w1;
        g(ii).perp(jj).w3 = w3;
        
    end
    
end
%3. combine subensembles
for ii = 1:n_subensembles
    for jj = 1:n_t2
        g_tot.para(jj).w1 = w1;
        g_tot.para(jj).w3 = w3;
        g_tot.perp(jj).w1 = w1;
        g_tot.perp(jj).w3 = w3;
        
        if ii == 1 && jj == 1
            [g_tot.para(1:n_t2).R] = deal(zeros(size(W1)));
            [g_tot.perp(1:n_t2).R] = deal(zeros(size(W1)));
        end
        g_tot.para(jj).R = g_tot.para(jj).R + g(ii).para(jj).R;
        g_tot.perp(jj).R = g_tot.perp(jj).R + g(ii).perp(jj).R;
        g_tot.para(jj).t2 = g(ii).para(jj).t2;%*1000;
        g_tot.perp(jj).t2 = g(ii).perp(jj).t2;%*1000;
        
    end
end

%4. set up outputs
% output g_tot, g(1:n_subensembles)
%g_tot.para
%g_tot
end

function g = myConstructor %(n_s,opt)
g = struct('para',[],'perp',[]);
g.para = construct2d;
g.perp = construct2d;%changed from construct2dPP
end

function jpd = gaussianJPD(W1,W3,w0,amp,sigma,corr)
%2D joint probability density

X = W1-w0;
Y = W3-w0;
D2 = (X+Y).^2./2;%diagonal squared
A2 = (X-Y).^2./2; %antidiagonal squared
dy=Y(2)-Y(1);
dx=dy;
sigma_d2 = sigma^2.*(1+corr^2);
sigma_a2 = sigma^2.*(1-corr^2);

jpd = amp/sqrt(2*pi*sigma_d2)/sqrt(2*pi*sigma_a2)...
    .*exp(-D2./(2*sigma_d2))...
    .*exp(-A2./(2*sigma_a2));
fprintf(1,'norm check should amp?=norm %f?=%f\n',amp,sum(sum(jpd))*dx*dy);
end
