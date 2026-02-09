function output = RISDFitWobbling2cone1SSD(t2,order,pfita,g)
% RISDFitWobbling2 v34 of a code to fit para and perp data to a RISD 
% with a wobbling in multiple (hardcoded to 3) cones model (cjk)
% this is explicitly for Giammanco2016 where structural and vectorial SSDs
% are separated
persistent R old_order

%ncones = 4;

tr1 = pfita(1);
theta_deg1 = pfita(2);
tr2 = pfita(3);
theta_deg2 = pfita(4);
amp1 = g(1);
tau1 = g(2);

%param struct for R must have these fields tr theta_deg 
p(1).tr = tr1;
p(1).theta_deg = theta_deg1;
p(2).tr = tr2;
p(2).theta_deg = theta_deg2;



%Look to see if we need to (re)initialize R
if isempty(R)||isempty(old_order)||old_order~=order
    disp('new R');
    
    [C,S] = wobblingC;
    Ctot = cell(1,4);
    
    for l = 1:4
        %Ctot{l} = 1;
        %for ii = 1:ncones
            Ctot{l}=@(p,t)C{l}(p(1),t)... %cone 1
                    .*C{l}(p(2),t);
        %end
    end
    
    R = wobblingR(Ctot,order);
    old_order=order;

end
output = [amp1.*exp(-t2./tau1).*R.para(p,t2); amp1.*exp(-t2./tau1).*R.perp(p,t2)];



