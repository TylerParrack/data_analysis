
function output = C2_RISDFitWobbling3(t2,order,p_in)
% RISDFitWobbling2 v3 of a code to fit para and perp data to a RISD 
% with a wobbling in a cone model
% 
persistent Ctot old_order

a = p_in(1);
tr = p_in(2);
theta_deg = p_in(3);

%param struct for R must have these fields tr theta_deg 
p.tr = tr;
p.theta_deg = theta_deg;

%Look to see if we need to (re)initialize R
if isempty(Ctot)||isempty(old_order)||old_order~=order
    disp('new R');
    R = wobbling(order);
    old_order=order;
    
    C = wobblingC;
    Ctot = cell(1,4);
    
    for l = 1:4
        %Ctot{l} = 1;
        %for ii = 1:ncones
            Ctot{l}=@(p,t)C{l}(p,t);
        %end
    end
  
    
end
  output = a.*(Ctot{2}(p,t2));
  
