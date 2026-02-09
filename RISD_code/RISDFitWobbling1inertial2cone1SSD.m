function output = RISDFitWobbling1inertial2cone1SSD(t2,order,pfita,g)
% RISDFitWobbling2 v34 of a code to fit para and perp data to a RISD 
% with a wobbling in multiple (hardcoded to 3) cones model (cjk)
% 
persistent R old_order

%ncones = 4;

theta_deg0 = pfita(1);
tr1 = pfita(2);
theta_deg1 = pfita(3);
tr2 = pfita(4);
theta_deg2 = pfita(5);
ampSSD = g(1);
tauSSD = g(2);

%param struct for R must have these fields tr theta_deg 
p(1).theta_deg = theta_deg0;
p(2).tr = tr1;
p(2).theta_deg = theta_deg1;
p(3).tr = tr2;
p(3).theta_deg = theta_deg2;


%Look to see if we need to (re)initialize R
if isempty(R)||isempty(old_order)||old_order~=order
    disp('new R');
    
    [C,S] = wobblingC;
    Ctot = cell(1,4);
    
    
    for l = 1:4
        %Ctot{l} = 1;
        %for ii = 1:ncones
            Ctot{l}=@(p,t)((S{l}(p(1))).^2).*C{l}(p(2),t).*C{l}(p(3),t);
        %end
    end
    
    R = wobblingR(Ctot,order);
    old_order=order;
end

output = [(ampSSD.*exp(-t2./tauSSD)).*R.para(p,t2); (ampSSD.*exp(-t2./tauSSD)).*R.perp(p,t2)];
