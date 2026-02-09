function output = RISDFitWobbling2cone(t2,order,pfita)
% RISDFitWobbling2 v34 of a code to fit para and perp data to a RISD 
% with a wobbling in multiple (hardcoded to 3) cones model (cjk)
% 
persistent R old_order

%ncones = 3;


tr1 = pfita(1);
theta_deg1 = pfita(2);
tr2 = pfita(3);
theta_deg2 = pfita(4);


%param struct for R must have these fields tr theta_deg 
p(1).tr = tr1;
p(1).theta_deg = theta_deg1;
p(2).tr = tr2;
p(2).theta_deg = theta_deg2;


%Look to see if we need to (re)initialize R
if isempty(R)||isempty(old_order)||old_order~=order
    disp('new R');
    
    C = wobblingC;
    Ctot = cell(1,4);
    
    
    for l = 1:4
        %Ctot{l} = 1;
        %for ii = 1:ncones
            Ctot{l}=@(p,t)C{l}(p(1),t).*C{l}(p(2),t);
        %end
    end
    
    R = wobblingR(Ctot,order);
    old_order=order;
end

output = [R.para(p,t2); R.perp(p,t2)];
