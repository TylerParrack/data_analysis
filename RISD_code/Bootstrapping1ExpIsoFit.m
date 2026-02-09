function output = Bootstrapping1ExpIsoFit(t2,order,p_in)
% RISDFit code that is just a triexponential fit for anisotropy or CLS
% 


tr1 = p_in(1);




output = exp(-t2/tr1);