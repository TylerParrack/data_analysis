function [R] = wobblingRFieldWA(Ctot,stark_effect_order,BetaV)
% wobbling in a cone model of Kramer Nishda Fayer JCP 2016
% This file has parameters solved by eq 13 in Hoffman2021 (numerically the
% same as Table 1)
S{1} = @(BetaV) (coth(BetaV)-1/BetaV)/BetaV;
S{2} = @(BetaV) ((BetaV^2+3)-3*BetaV*coth(BetaV))/BetaV^3;
S{3} = @(BetaV) ((BetaV^2+15)*(BetaV)*coth(BetaV-6*BetaV^2-15))/BetaV^3; %Actually unnecessary unless you want to show the t->inf points
 
a = @(BetaV) 1/3 + 2/3*(S{2}(BetaV));
b = @(BetaV) (S{1}(BetaV))^2;

switch stark_effect_order
    case 1 % from Kramer2015a
R.paraInt =@(p,x) (3/25).*((11.*Ctot{1}(p,x) + 4.*Ctot{3}(p,x))./(1 + 0.8.*Ctot{2}(p,x)));
R.perpInt =@(p,x) (3/25).*(( 7.*Ctot{1}(p,x) - 2.*Ctot{3}(p,x))./(1 - 0.4.*Ctot{2}(p,x)));
R.isoInt  =@(p,x) Ctot{1}(p,x);
    case 2 % from 
R.paraInt =@(p,x) (1/175).*((28 + 215.*Ctot{2}(p,x) + 72.*Ctot{4}(p,x))./(1 + 0.8.*Ctot{2}(p,x)));
R.perpInt =@(p,x) (1/175).*((-14 + 155.*Ctot{2}(p,x) - 36.*Ctot{4}(p,x))./(1 - 0.4.*Ctot{2}(p,x)));
R.isoInt  =@(p,x) Ctot{2}(p,x);
    otherwise
        error('only order 1 and 2 coded');
end

R.para =@(p,x,BetaV) ((1-b(BetaV))*R.paraInt(p,x)+(b(BetaV)-b(BetaV)/a(BetaV)).*Ctot{1}(p,x)-b(BetaV)+(b(BetaV)^2)/a(BetaV))/((1-b(BetaV))*(1-b(BetaV)/a(BetaV)));
R.perp =@(p,x,BetaV) ((1-b(BetaV))*R.perpInt(p,x)+(b(BetaV)-b(BetaV)/a(BetaV)).*Ctot{1}(p,x)-b(BetaV)+(b(BetaV)^2)/a(BetaV))/((1-b(BetaV))*(1-b(BetaV)/a(BetaV)));
R.iso  =@(p,x,BetaV) ((1-b(BetaV))*R.isoInt(p,x) +(b(BetaV)-b(BetaV)/a(BetaV)).*Ctot{1}(p,x)-b(BetaV)+(b(BetaV)^2)/a(BetaV))/((1-b(BetaV))*(1-b(BetaV)/a(BetaV)));
end