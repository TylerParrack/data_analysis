function output = Bootstrapping2ExpFitOffset(t2,order,p_in)
% RISDFit code that is just a triexponential fit for anisotropy or CLS
% 


a1 = p_in(1);
tr1 = p_in(2);
a2 = p_in(3);
tr2 = p_in(4);
c = p_in(5);


output = a1.*exp(-t2/tr1) + a2.*exp(-t2/tr2) + c;