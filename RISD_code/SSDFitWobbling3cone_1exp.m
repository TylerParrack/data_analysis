function output = SSDFitWobbling1inertial1cone1diff_1exp(t2,order,C,p_in)
% v1 of a code to take outputs from C2_RISDFitWobbling4 (1 amp, 3 cones)
% and calculate the RISD term and incorporate a biexponential SSD term from Kramer2015
% primarily based on code developed by CJK and SGR (RISDFitWobbling4)

persistent R old_order F 

%bringing in the set angle and times from anisotropy data (C2)
%mostly ripped directly from RISDFitWobbling4 and C2_RISDFitWobbling4

theta_deg0 = C(1);
tr1 = C(2);
theta_deg1 = C(3);
tr2 = C(4);

%param struct for R must have these fields tr theta_deg 

p(1).theta_deg = theta_deg0;
p(2).tr = tr1;
p(2).theta_deg = theta_deg1;
p(3).tr = tr2;


%Look to see if we need to (re)initialize R
if isempty(R)||isempty(old_order)||old_order~=order
%     disp('new R');
    
    [C,S] = wobblingC;
    Ctot = cell(1,4);
    
    
    for l = 1:4
        %Ctot{l} = 1;
        %for ii = 1:ncones
            Ctot{l}=@(p,t)C{l}(p(1),t).*C{l}(p(2),t).*C{l}(p(3),t);
        %end
    end
    
         R = wobblingR(Ctot,order);
         old_order=order;
end
%Let's include the new SSD portion

%inputs from p, assuming biexponential with two varying amplitudes
    q(1) = p_in(1);
    q(2) = p_in(2); %SSD timescale 1

    
        F =@(q,t)q(1).*exp(-t./q(2)); %triexponential SSD term


 
output = [F(q,t2).*(R.para(p,t2)); F(q,t2).*(R.perp(p,t2))];
