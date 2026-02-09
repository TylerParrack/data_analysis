stark_effect_order=2;
opt.t2_array = [0.2 0.3 0.4 0.5 0.6 0.8 1.0 1.2 1.4 1.6 1.8 2.0 2.5 3.0 3.5 4.0 5.0 6.0 8.0 10.0 12.5 15.0...
    17.5 20.0 22.5 25.0 27.5 30.0 35.0 40.0 45.0 50.0 55.0 60.0 65.0 70.0 75.0 87.5 100.0]; %125.0 150.0 ...
    %175.0 200.0 250.0];

subens_params(1).t_or=72.2; %2-point rotational times (from anisotropy type measure)
subens_params(1).tr=subens_params(1).t_or; %alias for 2-point rotational time
subens_params(1).T1=1; %VER time constant
%better agreement with experiment, still not fitting the line correctly and
%also where do I...obtain the numbers for those lines??
subens_params(1).w0=2340; %center frequency
subens_params(1).prob=1; %probability (amplitudes)
subens_params(1).sigma=3; %linewidth
subens_params(1).c0=1; %initial value of corr
subens_params(1).theta_deg=15;%cone half angle


[R,O]=wobbling(stark_effect_order)

oPara = O.para;
oPerp = O.perp;

R_para = R.para 
R_perp = R.perp
R_iso = R.iso

%%
pl = R_para(subens_params(1),opt.t2_array)
pl2 = R_perp(subens_params(1),opt.t2_array)
hold on
plot(opt.t2_array,pl,'-ok')
plot(opt.t2_array,pl2,'-or')