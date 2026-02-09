
function output = RISDFitWobbling3test(t2,order,p_in)
% RISDFitWobbling2 v3 of a code to fit para and perp data to a RISD 
% with a wobbling in a cone model
% 
persistent R old_order

a = p_in(1);
tr = p_in(2);
theta_deg = p_in(3);

%param struct for R must have these fields tr theta_deg 
p.tr = tr;
p.theta_deg = theta_deg;

%Look to see if we need to (re)initialize R

if isempty(R)||isempty(old_order)||old_order~=order
%     disp('new R');
    
    C = wobblingC;
    Ctot = cell(1,4);
    
    
    for l = 1:4
        %Ctot{l} = 1;
        %for ii = 1:ncones
            Ctot{l}=@(p,t)C{l}(p(1),t);
        %end
    end
    
    R = wobblingRtest(Ctot,order);
    old_order=order;
end

output = [a.*R.para(p,t2); a.*R.perp(p,t2)];

