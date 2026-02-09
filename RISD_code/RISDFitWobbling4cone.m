function output = RISDFitWobbling4cone(t2,order,p_in)
% RISDFitWobbling2 v34 of a code to fit para and perp data to a RISD 
% with a wobbling in multiple (hardcoded to 3) cones model (cjk)
% 
persistent R old_order

%ncones = 4;


tr1 = p_in(1);
theta_deg1 = p_in(2);
tr2 = p_in(3);
theta_deg2 = p_in(4);
tr3 = p_in(5);
theta_deg3 = p_in(6);
tr4 = p_in(7);
theta_deg4 = p_in(8);

%param struct for R must have these fields tr theta_deg 
p(1).tr = tr1;
p(1).theta_deg = theta_deg1;
p(2).tr = tr2;
p(2).theta_deg = theta_deg2;
p(3).tr = tr3;
p(3).theta_deg = theta_deg3;
p(4).tr = tr4;
p(4).theta_deg = theta_deg4;


%Look to see if we need to (re)initialize R
if isempty(R)||isempty(old_order)||old_order~=order
    disp('new R');
    
    C = wobblingC;
    Ctot = cell(1,4);
    
    
    for l = 1:4
        %Ctot{l} = 1;
        %for ii = 1:ncones
            Ctot{l}=@(p,t)C{l}(p(1),t).*C{l}(p(2),t).*C{l}(p(3),t).*C{l}(p(4),t);
        %end
    end
    
    R = wobblingR(Ctot,order);
    old_order=order;
end

output = [R.para(p,t2); R.perp(p,t2)];
