function output = Bootstrapping2VoigtFit(t2,order,p_in)
% RISDFit code that is just a triexponential fit for anisotropy or CLS
% 

a1 = p_in(1);
a2 = p_in(2);
xc1 = p_in(3);
xc2 = p_in(4);
wg1 = p_in(5);
wl1 = p_in(6);



output = a1.*voigt(t2,xc1,wg1,wl1) + a2.*voigt(t2,xc2,wg1,wl1);