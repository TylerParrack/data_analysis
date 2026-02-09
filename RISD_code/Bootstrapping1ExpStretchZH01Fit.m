function output = Bootstrapping1ExpStretchZH01Fit(t2,order,p_in)
% RISDFit code that is just a triexponential fit for anisotropy or CLS
% 


a1 = p_in(1);
tr2 = p_in(2);


% we are using the stretch exponential long time term from the paper
output = (1-a1).*exp(-((t2/tr2).^0.4)) ;