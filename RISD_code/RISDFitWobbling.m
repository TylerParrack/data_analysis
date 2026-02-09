function out = RISDFitWobbling(a,tr,theta_deg,t2x,t2y)
persistent R R_para R_perp %deprecated

p.tr = tr;
p.theta_deg = theta_deg;

if isempty(R)
    R = wobbling;
    R_para = R.para;
    R_perp = R.perp;
end

out = (t2x>0).*a.*R_para(p,t2x)+(t2y>0).*a.*R_perp(p,t2y);
end