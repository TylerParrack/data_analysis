function output = SSDFitWobbling1cone_1exp(t2,order,C,p_in)
% v1 of a code to take outputs from C2_RISDFitWobbling4 (1 amp, 3 cones)
% and calculate the RISD term and incorporate a biexponential SSD term from Kramer2015
% primarily based on code developed by CJK and SGR (RISDFitWobbling4)

persistent R old_order F 

%bringing in the set angle and times from anisotropy data (C2)
%mostly ripped directly from RISDFitWobbling4 and C2_RISDFitWobbling4

tr1 = C(1);
theta_deg1 = C(2);


%param struct for R must have these fields tr theta_deg 

p(1).tr = tr1;
p(1).theta_deg = theta_deg1;


%Look to see if we need to (re)initialize R
if isempty(R)||isempty(old_order)||old_order~=order
%     disp('new R');
    
    C = wobblingC;
    Ctot = cell(1,4);
    
    %calculate all the C{l} parameters from the anisotropy outputs (C{2})
    for l = 1:4
            Ctot{l}=@(p,t)C{l}(p(1),t);
    end
    
    %calculate the RISD fit from those C{l} values
    
     R = wobblingR(Ctot,order);
     old_order=order;
end
%Let's include the new SSD portion

%inputs from p, assuming biexponential with two varying amplitudes
    q(1) = p_in(1);
    q(2) = p_in(2); %SSD timescale 1

    
        F =@(q,t)q(1).*exp(-t./q(2)); %exponential SSD term


 
output = [F(q,t2).*(R.para(p,t2)); F(q,t2).*(R.perp(p,t2))];
