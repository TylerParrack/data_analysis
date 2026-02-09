
% clear opt
% %inputs
% opt.t2_array = [0.2 0.3 0.4 0.5 0.6 0.8 1.0 1.2 1.4 1.6 1.8 2.0 2.5 3.0 3.5 4.0 5.0 6.0 8.0 10.0 12.5 15.0...
%     17.5 20.0 22.5 25.0 27.5 30.0 35.0 40.0 45.0 50.0 55.0 60.0 65.0 70.0 75.0 87.5 100.0 125.0 150.0 ...
%     175.0 200.0 250.0];
% %opt.w1 = [2330:0.5:2350]; %for plotting/2DAnisotropy stuff
% opt.w1 = [2332:0.5:2350]; %for fitting/CLS stuff.
% opt.w3 = opt.w1;
% opt.stark_effect_order = 2;
% 
% subens_params(1).T1=30; %VER time constant [single exponential decay calc'd from isotropic data]
% subens_params(1).w0=2341; %center frequency 
% subens_params(1).prob=1; %probability (amplitudes) (I only have one subensemble)
% subens_params(1).sigma=2.75; %fwhm = 2.355*sigma (fwhm of this peak in FTIR = 6.5cm-1)
% 
% subens_params(1).c0=0.835; %initial value of corr
% 
% subens_params(1).t_or=0.341; %2-point rotational times (from anisotropy type measure)
% subens_params(1).tr=subens_params(1).t_or; %alias for 2-point rotational time
% subens_params(1).theta_deg=23.7;%cone half angle
%  
% subens_params(1).t_or2=9.3; %2-point rotational times (from anisotropy type measure)
% subens_params(1).tr2=subens_params(1).t_or2; %alias for 2-point rotational time
% subens_params(1).theta_deg2=23.1;%cone half angle
%  
% subens_params(1).t_or3=105.5; %2-point rotational times (from anisotropy type measure)
% subens_params(1).tr3=subens_params(1).t_or3; %alias for 2-point rotational time
% subens_params(1).theta_deg3=63;%cone half angle
%%
% clear opt subens_params
% % inputs
% opt.t2_array = [0.2 0.3 0.4 0.5 0.6 0.8 1.0 1.2 1.4 1.6 1.8 2.0 2.5 3.0 3.5 4.0 5.0 6.0 8.0 10.0 12.5 15.0...
%     17.5 20.0 22.5 25.0 27.5 30.0 35.0 40.0 45.0 50.0 55.0 60.0 65.0 70.0 75.0 87.5 100.0 125.0 150.0 ...
%     175.0 200.0 250.0];
% opt.w1 = [2330:0.5:2350]; %for plotting/2DAnisotropy stuff
% %opt.w1 = [2337:0.5:2347]; %for fitting/CLS stuff.
% opt.w3 = opt.w1;
% opt.stark_effect_order = 2;
% 
% subens_params(1).T1=30; %VER time constant [single exponential decay calc'd from isotropic data]
% subens_params(1).w0=2341; %center frequency 
% subens_params(1).prob=1; %probability (amplitudes) (I only have one subensemble)
% subens_params(1).sigma=2.75; %fwhm = 2.355*sigma (fwhm of this peak in FTIR = 6.5cm-1)
% 
% subens_params(1).c0 = 1; %initial value of corr
% 
% subens_params(1).t_or=1; %2-point rotational times (from anisotropy type measure)
% subens_params(1).tr=subens_params(1).t_or; %alias for 2-point rotational time
% subens_params(1).theta_deg=170;%cone half angle
% 
% % subens_params(1).t_or=1; %2-point rotational times (from anisotropy type measure)
% % subens_params(1).tr=subens_params(1).t_or; %alias for 2-point rotational time
% % subens_params(1).theta_deg=175;%cone half angle
%  
% % subens_params(1).t_or2=0.5; %2-point rotational times (from anisotropy type measure)
% % subens_params(1).tr2=subens_params(1).t_or2; %alias for 2-point rotational time
% % subens_params(1).theta_deg2=20;%cone half angle
% %  
% % subens_params(1).t_or3=0.5; %2-point rotational times (from anisotropy type measure)
% % subens_params(1).tr3=subens_params(1).t_or3; %alias for 2-point rotational time
% % subens_params(1).theta_deg3=20;%cone half angle

%%
clear opt
%inputs
opt.t2_array = [0.2 0.3 0.4 0.5 0.6 0.8 1.0 1.2 1.4 1.6 1.8 2.0 2.5 3.0 3.5 4.0 5.0 6.0 8.0 10.0 12.5 15.0...
    17.5 20.0 22.5 25.0 27.5 30.0 35.0 40.0 45.0 50.0 55.0 60.0 65.0 70.0 75.0 87.5 100.0 125.0 150.0 ...
    175.0 200.0 250.0];
opt.w1 = [2330:0.5:2350]; %for plotting/2DAnisotropy stuff
%opt.w1 = [2332:0.5:2350]; %for fitting/CLS stuff.
opt.w3 = opt.w1;
opt.stark_effect_order = 2;

subens_params(1).T1=30; %VER time constant [single exponential decay calc'd from isotropic data]
subens_params(1).w0=2341; %center frequency 
subens_params(1).prob=1; %probability (amplitudes) (I only have one subensemble)
subens_params(1).sigma=2.75; %fwhm = 2.355*sigma (fwhm of this peak in FTIR = 6.5cm-1)

subens_params(1).c01=0.6977; %initial value of corr (para)
subens_params(1).c02=0.6241; %inital value of corr (perp)

subens_params(1).t_or=8.5; %2-point rotational times (from anisotropy type measure)
subens_params(1).tr=subens_params(1).t_or; %alias for 2-point rotational time
subens_params(1).theta_deg=23.3;%cone half angle
 
subens_params(1).t_or2=98; %2-point rotational times (from anisotropy type measure)
subens_params(1).tr2=subens_params(1).t_or2; %alias for 2-point rotational time
subens_params(1).theta_deg2=66.86;%cone half angle
 

%  
