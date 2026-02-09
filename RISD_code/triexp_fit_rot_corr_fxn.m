subens_params(1).c0_xx=0.835; %initial value of corr

subens_params(1).t_or=0.341; %2-point rotational times (from anisotropy type measure)
subens_params(1).tr=subens_params(1).t_or; %alias for 2-point rotational time
subens_params(1).theta_deg=23.7;%cone half angle
 
subens_params(1).t_or2=9.3; %2-point rotational times (from anisotropy type measure)
subens_params(1).tr2=subens_params(1).t_or2; %alias for 2-point rotational time
subens_params(1).theta_deg2=23.1;%cone half angle
 
subens_params(1).t_or3=105.5; %2-point rotational times (from anisotropy type measure)
subens_params(1).tr3=subens_params(1).t_or3; %alias for 2-point rotational time
subens_params(1).theta_deg3=63;%cone half angle

stark_effect_order = 2;
t2_array = [0.2 0.3 0.4 0.5 0.6 0.8 1.0 1.2 1.4 1.6 1.8 2.0 2.5 3.0 3.5 4.0 5.0 6.0 8.0 10.0 12.5 15.0...
    17.5 20.0 22.5 25.0 27.5 30.0 35.0 40.0 45.0 50.0 55.0 60.0 65.0 70.0 75.0 87.5 100.0 125.0 150.0 ...
    175.0 200.0 250.0];
%%
 C = wobblingC;
    Ctot = cell(1,4);
    
    in(1).tr = subens_params.tr;
    in(1).theta_deg = subens_params.theta_deg;
    in(2).tr = subens_params.tr2;
    in(2).theta_deg = subens_params.theta_deg2;
    in(3).tr = subens_params.tr3;
    in(3).theta_deg = subens_params.theta_deg3;
   
    for l = 1:4
        %Ctot{l} = 1;
        %for ii = 1:ncones
            Ctot{l}=@(p,t)C{l}(in(1),t).*C{l}(in(2),t).*C{l}(in(3),t);
        %end
    end
    
    L2 = Ctot{2}(subens_params,t2_array)

%%
plot(t2_array,L2,'o')

%%
trix = fittype( @(a1, a2, a3, t1, t2, t3, x) a1.*exp(-(x./t1))+a2.*exp(-(x./t2))+a3.*exp(-(x./t3)),...
    'coeff', {'a1',  'a2', 'a3', 't1', 't2','t3'}, 'indep', {'x'});
sp = [.2 .2 .2 1 25 75];
lb = [0 0 0 0.05 1 10];
ub = [.5 .5 .5 10 100 250];

fr=fit(t2_array',L2',trix,'Startpoint',sp,'Lower',lb,'Upper',ub);

hold on
plot(t2_array,fr(t2_array),'-')

fr