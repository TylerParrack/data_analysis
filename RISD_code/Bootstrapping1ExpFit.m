function output = Bootstrapping1ExpFit(t2,order,p_in)
% RISDFit code that is just a triexponential fit for anisotropy or CLS
% 


a1 = p_in(1);
tr1 = p_in(2);




output = a1.*exp(-t2/tr1);