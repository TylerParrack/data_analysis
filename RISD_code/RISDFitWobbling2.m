function output = RISDFitWobbling2(t2,data_y,data_std,logical_para,logical_perp,order,p_in)%deprecated
% RISDFitWobbling2 v2 of a code to fit para and perp data to a RISD 
% with a wobbling in a cone model
% GIVING UP AND STARTING OVER
persistent R

a = p_in(1);
tr = p_in(2);
theta_deg = p_in(3);

%param struct for R must have these fields tr theta_deg 
p.tr = tr;
p.theta_deg = theta_deg;

if isempty(R)
    R = wobbling(order);
end

t2x = [t2,zeros(size(t2))];
t2y = [zeros(size(t2)),t2];
t2n = [t2 t2];



    CFOptions.fitfcn = fittype( @(a,tr,theta_deg,t2)...
        (t2x>0) .*(a.*R.para(p,t2x)) ...
        +(t2y>0).*(a.*R.perp(p,t2y)),...
  'coeff', {'a1','tr','theta_deg'}, 'indep', {'t2'});
   
output = CFOptions.fitfcn(p_in(1),p_in(2),t2x,t2y);%t2n);

output = logicala.*R.para(p,t2x)) +(t2y>0).*(a.*R.perp(p,t2y)),...
