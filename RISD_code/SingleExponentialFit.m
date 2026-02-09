function output = SingleExponentialFit(t2,p_in)
% RISDFitWobbling2 v34 of a code to fit para and perp data to a RISD 
% with a wobbling in multiple (hardcoded to 3) cones model (cjk)
% 
% persistent Ctot old_order

%ncones = 3;

amp_1 = p_in(1);
tau_1 = p_in(2);


output = amp_1.*exp(-t2./tau_1);

