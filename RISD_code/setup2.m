%
% inputs
%

%put these in a structure instead:
opt.t2_array = [0.2:1:12.2]; %list of t2 times
opt.w1 = [2000:4:2100];
opt.w3 = opt.w1;

%parameters for each subensemble
%subsensemble 1
subens_params(1).t_or=16; %2-point rotational times (from anisotropy type measure)
subens_params(1).T1=2.5; %VER time constant
subens_params(1).w0=2064-16; %center frequency
subens_params(1).prob=1.4; %probability (amplitudes)
subens_params(1).sigma=17; %linewidth
subens_params(1).c0=0.8; %initial value of corr

%subsensemble 2
subens_params(2).t_or=16; %2-point rotational times (from anisotropy type measure)
subens_params(2).T1 = 5.7; %VER time constant
subens_params(2).w0=2064; %center frequency
subens_params(2).prob = 1; %probability (amplitudes)
subens_params(2).sigma=14; %linewidth
subens_params(2).c0=0.8; %initial value of corr

