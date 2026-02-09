function output = BootstrappingGaussianFit(x,p_in)


amp = p_in(1);
mu = p_in(2);
sigma = p_in(3);

output = amp.*exp(-0.5.*((x-mu)/sigma).^2)./sigma./sqrt(2*pi);