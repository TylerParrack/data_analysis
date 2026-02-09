
clear opt
%inputs
opt.t2_array = [200;
                300;
                400;
                500;
                600;
                700;
                800;
                900;
                1000;
                1200;
                1500;
                1700;
                2000;
                2500;
                3000;
                4000;
                5000;
                7500;
                10000;
                15000;
                20000;
                40000;
                60000;
                80000;
                100000;
                125000;
                150000;
                175000;
                200000;
                225000;
                250000;]./1000;
%opt.w1 = [2330:0.5:2350]; %for plotting/2DAnisotropy stuff
opt.w1 = [2180:1:2240]; %for fitting/CLS stuff.
opt.w3 = opt.w1;
opt.stark_effect_order = 1;

subens_params(1).T1=61.51; %VER time constant [single exponential decay calc'd from isotropic data]
subens_params(1).w0=2228; %center frequency 
subens_params(1).prob=1; %probability (amplitudes) (I only have one subensemble)
subens_params(1).sigma=5.09; %fwhm = 2.355*sigma (fwhm of this peak in FTIR = 6.5cm-1)

subens_params(1).c0=0.85; %F(t)

subens_params(1).t_or=30; %2-point rotational times (from anisotropy type measure)
subens_params(1).tr=subens_params(1).t_or; %alias for 2-point rotational time
subens_params(1).theta_deg=70;%cone half angle
 
%  subens_params(1).t_or2=9.3; %2-point rotational times (from anisotropy type measure)
%  subens_params(1).tr2=subens_params(1).t_or2; %alias for 2-point rotational time
%  subens_params(1).theta_deg2=23.1;%cone half angle
%  
%  subens_params(1).t_or3=105.5; %2-point rotational times (from anisotropy type measure)
%  subens_params(1).tr3=subens_params(1).t_or3; %alias for 2-point rotational time
%  subens_params(1).theta_deg3=63;%cone half angle


