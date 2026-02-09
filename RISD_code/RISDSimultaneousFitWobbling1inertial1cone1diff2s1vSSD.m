function output = RISDSimultaneousFitWobbling1inertial1cone1diff1s2vSSD(t2,order,g)
% RISDFitWobbling2 v34 of a code to fit para and perp data to a RISD 
% with a wobbling in multiple (hardcoded to 3) cones model (cjk)
% this is explicitly for Giammanco2016 where structural and vectorial SSDs
% are separated
persistent R old_order

t2a = t2{1};
t2ffcf = t2{2};

theta_deg0 = g{1}(1);
tr1        = g{1}(2);
theta_deg1 = g{1}(3);
tr3        = g{1}(4);
ampSSDs1   = g{2}(1);
tauSSDs1   = g{2}(2);
ampSSDv1   = g{2}(3);
tauSSDv1   = g{2}(4);
ampSSDv2   = g{2}(5);
tauSSDv2   = g{2}(6);
%param struct for R must have these fields tr theta_deg 
p(1).theta_deg = theta_deg0;
p(2).tr = tr1;
p(2).theta_deg = theta_deg1;
p(3).tr = tr3;



%Look to see if we need to (re)initialize R
if isempty(R)||isempty(old_order)||old_order~=order
    disp('new R');
    
    [C,S] = wobblingC;
    Ctot = cell(1,4);
    
    for l = 1:4
        %Ctot{l} = 1;
        %for ii = 1:ncones
            Ctot{l}=@(p,t)((S{l}(p(1))).^2) ... %inertial cone is just S^2
                    .*C{l}(p(2),t)... %cone 1
                    .*exp(-(l*(l+1)./(6*p(3).tr)).*t);
        %end
    end
    
    R = wobblingR(Ctot,order);
    old_order=order;

output = {0.4.*(Ctot{2}(p,t2a));
          ampSSDs1.*exp(-t2ffcf./tauSSDs1) + (ampSSDv1.*exp(-t2ffcf./tauSSDv1) + ampSSDv2.*exp(-t2ffcf./tauSSDv2)).*R.para(p,t2ffcf); 
          ampSSDs1.*exp(-t2ffcf./tauSSDs1) + (ampSSDv1.*exp(-t2ffcf./tauSSDv1) + ampSSDv2.*exp(-t2ffcf./tauSSDv2)).*R.perp(p,t2ffcf)};
end
