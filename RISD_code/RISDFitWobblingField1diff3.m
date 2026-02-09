function output = RISDFitWobblingField1diff3(t2,order,p_in,tau_m)
% RISDFitWobbling2 v34 of a code to fit para and perp data to a RISD 
% with a wobbling in multiple (hardcoded to 3) cones model (cjk)
% 
persistent R old_order

%ncones = 3;

tr1 = tau_m;
BetaV   = p_in(1);

%param struct for R must have these fields tr theta_deg 
p(1).tr = tr1;


%Look to see if we need to (re)initialize R
if isempty(R)||isempty(old_order)||old_order~=order
    disp('new R');
    
    [C,S] = wobblingC;
    Ctot = cell(1,4);
    
    for l = 1:4
        %Ctot{l} = 1;
        %for ii = 1:ncones
            Ctot{l}=@(p,t) (exp(-l.*(l+1)./(6.*p(1).tr).*t)) ; %single diffusive cone
        %end
    end
    
    R = wobblingRField3(Ctot,order,BetaV);
    old_order=order;
end

output = [R.para(p,t2,BetaV); R.perp(p,t2,BetaV); R.iso(p,t2,BetaV); R.iso2(p,t2,BetaV)];