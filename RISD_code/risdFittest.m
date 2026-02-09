classdef risdFittest
    properties
        t2;% time axis
        data_y; %[para_c2; perp_c2]
        data_std; %[para_c2_std; perp_c2_std]
        fxn; %function handle to RISD function fxn(t2,order,p)
        sim; %the evaluated model
        order; %order of stark effect 1 or 2
        useParallel=false;
        p0; %initial guess
        pfit; %final fit
        err; %error at final fit
        lb; %lower bound
        ub; %upper bounds
        nboot; %number of boot strapping iterations
        pboot; %fit params of bootstrapping
        tolfun = 1e-17;
        tolx = 1e-10;
        maxfun = 1e3; %maximum number of function evaluations

    end
    
    methods
        function obj = risdFittest(options)
            % assign properties from the input options struct
            props = properties(obj);
            for ii = 1:length(props)
                if isfield(options,props{ii})
                    obj.(props{ii}) = options.(props{ii});
                end
            end
        end
        
        function obj = calcSim(obj,p)
            %evaluate the model provided, save in sim
            obj.sim = obj.fxn(obj.t2,obj.order,p);
            
        end
        function sse = err_fun(obj,p)
            %calc sum of square error b/n model and data
            obj = obj.calcSim(p);
            for ii = 1:length(obj.data_y)
            sse(ii) = sum((obj.data_y{ii}-obj.sim{ii}).^2,'all');
            end
            sse = sum(sse);
        end
        
        function ssew = err_fun_w(obj,p)
            %calc weighted sum of square error b/n model and data
            obj = obj.calcSim(p);
            ssew =  sum((obj.data_y-obj.sim).^2./obj.data_std.^2,'all');
            
        end
        
        function sse = err_fun_boot(obj,p,ind)
            %calc sum of square error b/n model and data for bootstrapping
            obj = obj.calcSim(p);
            for ii = 1:length(obj.data_y)
            sse = sum((obj.data_y{ii}(ind)-obj.sim{ii}(ind)).^2,'all');
            end
            sse = sum(sse);
        end
        
        function sse = err_fun_boot_w(obj,p,ind)
            %calc weighted sum of square error b/n model and data for
            %bootstrapping
            obj = obj.calcSim(p);
            sse = sum((obj.data_y(ind)-obj.sim(ind)).^2./obj.data_std(ind).^2,'all');
            
        end
        
        function obj = globalFit(obj)%dataMatrix,w1,w3,p_array,gfstruct,lb,ub)
            
            % set fit parameters (I believe based on version of matlab)
            if exist('optimoptions','file')
                opt = optimoptions('fmincon','Algorithm','active-set','Display','iter','TolFun',obj.tolfun,'TolX',obj.tolx,'MaxFunEvals',obj.maxfun);
            elseif exist('optimset','file')
                %    opt = optimset('Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
                opt = optimset('Algorithm','active-set','Display','iter','TolFun',obj.tolfun,'TolX',obj.tolx,'MaxFunEvals',obj.maxfun);
            else
                warning('Could not set parameters! Look for the right options functon for your installation.');
            end
            
            opt = optimoptions(opt,'UseParallel',obj.useParallel);
            
            tic
            
            %fmincon has required parameters of error function and initial guess.
            %Documentation has a bunch of additional parameters, most of which we don't
            %understand, but the syntax for not using them is to leave them as blanks.
            [pfit,err] = fmincon(@(p)obj.err_fun(p),obj.p0,[],[],[],[],obj.lb,obj.ub,[],opt);
            
            toc
            
            obj.pfit = pfit;
            obj.err = err;
            
            %for ii = 1:length(pfit)
            %    fprintf(1,'%20s\t%12f\n',obj.freeParamNames{ii},pfit(ii));
            %end
        end
        
        function obj = globalFitBootstrap(obj)%dataMatrix,w1,w3,p_array,gfstruct,lb,ub)
            
            % set fit parameters (I believe based on version of matlab)
            if exist('optimoptions','file')
                opt = optimoptions('fmincon','Algorithm','active-set','Display','iter','TolFun',obj.tolfun,'TolX',obj.tolx,'MaxFunEvals',obj.maxfun);
            elseif exist('optimset','file')
                %    opt = optimset('Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
                opt = optimset('Algorithm','active-set','Display','iter','TolFun',obj.tolfun,'TolX',obj.tolx,'MaxFunEvals',obj.maxfun);
            else
                warning('Could not set parameters! Look for the right options functon for your installation.');
            end
            
            opt = optimoptions(opt,'UseParallel',obj.useParallel);
            
            obj.pboot = zeros(obj.nboot,length(obj.p0));
            npoints = numel(obj.sim);
            
            
            % go!
            bootStart = tic;
            for ii = 1:obj.nboot
                ind = randi(npoints,1,npoints);
                %[pboot(ii,:),err] = fmincon(@(p)obj.err_fun(p),obj.p0,[],[],[],[],obj.lb,obj.ub,[],opt);
                [obj.pboot(ii,:)] = fmincon(@(p,ind)obj.err_fun_boot(p,ind),obj.p0,[],[],[],[],obj.lb,obj.ub,[],opt,ind);
            end
            bootEnd = toc(bootStart);
            
            fprintf(1,'Elapsed time: %i seconds\n',bootEnd);
            % the 2 sigma limits should be 95% intervals
            %for ii = 1:size(obj.pboot,2)
            %    fprintf(1,'%20s\t%12f\tpm\t%12.3f\n',...
            %        obj.freeParamNames{ii},mean(obj.pboot(:,ii)),2*std(obj.pboot(:,ii)));
            %end
            
        end
        function obj = globalFitW(obj)%dataMatrix,w1,w3,p_array,gfstruct,lb,ub)
            
            % set fit parameters (I believe based on version of matlab)
            if exist('optimoptions','file')
                opt = optimoptions('fmincon','Algorithm','active-set','Display','iter','TolFun',obj.tolfun,'TolX',obj.tolx,'MaxFunEvals',obj.maxfun);
            elseif exist('optimset','file')
                %    opt = optimset('Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
                opt = optimset('Algorithm','active-set','Display','iter','TolFun',obj.tolfun,'TolX',obj.tolx,'MaxFunEvals',obj.maxfun);
            else
                warning('Could not set parameters! Look for the right options functon for your installation.');
            end
            
            opt = optimoptions(opt,'UseParallel',obj.useParallel);
            
            tic
            
            %fmincon has required parameters of error function and initial guess.
            %Documentation has a bunch of additional parameters, most of which we don't
            %understand, but the syntax for not using them is to leave them as blanks.
            [pfit,err] = fmincon(@(p)obj.err_fun_w(p),obj.p0,[],[],[],[],obj.lb,obj.ub,[],opt);
            
            toc
            
            obj.pfit = pfit;
            obj.err = err;
            
            %for ii = 1:length(pfit)
            %    fprintf(1,'%20s\t%12f\n',obj.freeParamNames{ii},pfit(ii));
            %end
        end
        
        function obj = globalFitBootstrapW(obj)%dataMatrix,w1,w3,p_array,gfstruct,lb,ub)
            
            % set fit parameters (I believe based on version of matlab)
            if exist('optimoptions','file'),
                opt = optimoptions('fmincon','Algorithm','active-set','Display','iter','TolFun',obj.tolfun,'TolX',obj.tolx,'MaxFunEvals',obj.maxfun);
            elseif exist('optimset','file'),
                %    opt = optimset('Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
                opt = optimset('Algorithm','active-set','Display','iter','TolFun',obj.tolfun,'TolX',obj.tolx,'MaxFunEvals',obj.maxfun);
            else
                warning('Could not set parameters! Look for the right options functon for your installation.');
            end
            
            opt = optimoptions(opt,'UseParallel',obj.useParallel);
            
            obj.pboot = zeros(obj.nboot,length(obj.p0));
            npoints = numel(obj.sim);
            
            
            % go!
            bootStart = tic;
            for ii = 1:obj.nboot;
                ind = randi(npoints,1,npoints);
                %[pboot(ii,:),err] = fmincon(@(p)obj.err_fun(p),obj.p0,[],[],[],[],obj.lb,obj.ub,[],opt);
                [obj.pboot(ii,:)] = fmincon(@(p,ind)obj.err_fun_boot_w(p,ind),obj.p0,[],[],[],[],obj.lb,obj.ub,[],opt,ind);
            end
            bootEnd = toc(bootStart);
            
            fprintf(1,'Elapsed time: %i seconds\n',bootEnd);
            % the 2 sigma limits should be 95% intervals
            %for ii = 1:size(obj.pboot,2)
            %    fprintf(1,'%20s\t%12f\tpm\t%12.3f\n',...
            %        obj.freeParamNames{ii},mean(obj.pboot(:,ii)),2*std(obj.pboot(:,ii)));
            %end
            
        end
        
    end
    
end