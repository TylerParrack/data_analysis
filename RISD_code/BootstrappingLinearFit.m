function output = BootstrappingLinearFit(x,p_in)


m = p_in(1);
b = p_in(2);


output = m.*x+b;