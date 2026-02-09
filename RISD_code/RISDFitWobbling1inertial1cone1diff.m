function output = RISDFitWobbling1inertial1cone1diff(t2,order,p_in)
% RISDFitWobbling2 v34 of a code to fit para and perp data to a RISD 
% with a wobbling in multiple (hardcoded to 3) cones model (cjk)
% 
persistent R old_order

%ncones = 4;

theta_deg0 = p_in(1);
tr1 = p_in(2);
theta_deg1 = p_in(3);
tr2 = p_in(4);


%param struct for R must have these fields tr theta_deg 
p(1).theta_deg = theta_deg0;
p(2).tr = tr1;
p(2).theta_deg = theta_deg1;
p(3).tr = tr2;



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

end
output = [R.para(p,t2); R.perp(p,t2)];



