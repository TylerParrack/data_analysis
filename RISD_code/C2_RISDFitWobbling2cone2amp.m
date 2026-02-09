function output = C2_RISDFitWobbling2cone2amp(t2,order,p_in)
% RISDFitWobbling2 v34 of a code to fit para and perp data to a RISD 
% with a wobbling in multiple (hardcoded to 3) cones model (cjk)
% 
persistent Ctot  old_order

%ncones = 3;

a1 = p_in(1);
a2 = p_in(2);
tr1 = p_in(3);
theta_deg1 = p_in(4);
tr2 = p_in(5);
theta_deg2 = p_in(6);


%param struct for R must have these fields tr theta_deg 
p(1).tr = tr1;
p(1).theta_deg = theta_deg1;
p(2).tr = tr2;
p(2).theta_deg = theta_deg2;


%Look to see if we need to (re)initialize R
if isempty(Ctot)||isempty(old_order)||old_order~=order
    disp('new C');
    
    C = wobblingC;
    Ctot = cell(1,4);
    
    
    for l = 1:4 
        %Ctot{l} = 1;
        %for ii = 1:ncones
            Ctot{l}=@(p,t)C{l}(p(1),t).*C{l}(p(2),t);
        %end
    end
    

end

output = (Ctot{2}(p,t2));


