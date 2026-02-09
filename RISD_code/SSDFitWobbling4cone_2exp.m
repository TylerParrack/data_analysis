function output = SSDFitWobbling4cone_2exp(t2,order,C,p_in)
% v1 of a code to take outputs from C2_RISDFitWobbling4 (1 amp, 3 cones)
% and calculate the RISD term and incorporate a biexponential SSD term from Kramer2015
% primarily based on code developed by CJK and SGR (RISDFitWobbling4)

persistent R old_order F 

%bringing in the set angle and times from anisotropy data (C2)
%mostly ripped directly from RISDFitWobbling4 and C2_RISDFitWobbling4

tr1 = C(1);
theta_deg1 = C(2);
tr2 = C(3);
theta_deg2 = C(4);
tr3 = C(5);
theta_deg3 = C(6);
tr4 = C(7);
theta_deg4 = C(8);

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
%     disp('new R');
    
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
%Let's include the new SSD portion

%inputs from p, assuming biexponential with two varying amplitudes
    q(1) = p_in(1);
    q(2) = p_in(2); %SSD timescale 1
    q(3) = p_in(3); 
    q(4) = p_in(4); %SSD timescale 2
     
        F =@(q,t)q(1).*exp(-t./q(2))+q(3).*exp(-t./q(4)); %biexponential SSD term


%  output = [(R.para(p,t2));(R.perp(p,t2))];
output = [F(q,t2).*(R.para(p,t2)); F(q,t2).*(R.perp(p,t2))];
