function output = RISDFitWobblingField1cone1diff0s0vSSD(t2,order,pfita,g)
% RISDFitWobbling2 v34 of a code to fit para and perp data to a RISD 
% with a wobbling in multiple (hardcoded to 3) cones model (cjk)
% this is explicitly for Giammanco2016 where structural and vectorial SSDs
% are separated
persistent R old_order

%ncones = 4;

tr1 = pfita(1);
theta_deg1 = pfita(2);
tr2 = pfita(3);

BetaV   = g(1);
ampSSDs1 = g(2);
ampSSDv1 = g(3);

%param struct for R must have these fields tr theta_deg 
p(1).tr = tr1;
p(1).theta_deg = theta_deg1;
p(2).tr = tr2;



%Look to see if we need to (re)initialize R
if isempty(R)||isempty(old_order)||old_order~=order
    disp('new R');
    
    [C,S] = wobblingC;
    Ctot = cell(1,4);
    
    for l = 1:4
        %Ctot{l} = 1;
        %for ii = 1:ncones
            Ctot{l}=@(p,t)C{l}(p(1),t)... %cone 1
                    .*exp(-(l*(l+1)./(6*p(2).tr)).*t);
        %end
    end
    
    R = wobblingRField(Ctot,order,BetaV);
    old_order=order;

end
output = [(ampSSDs1)+(ampSSDv1).*R.para(p,t2,BetaV); 
          (ampSSDs1)+(ampSSDv1).*R.perp(p,t2,BetaV)];



