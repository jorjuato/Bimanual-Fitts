function pfit=fit_trial_sa(mdl,tr,h,vname,initguess,do_plot)
    if nargin<6, do_plot=1; end
    if nargin<5, initguess=[]; end
    if nargin<4, vname='omega_phhist';end
    if nargin<3, h='';end
        
    y=tr.ts.([h,vname]);
    id=tr.info.([h,'ID']);
    mdl.conf.bins=length(y);
    
    function err=fitfcn1(p)
       mdl.load_param(p);
       mdl.run();
       if length(mdl.xpeaks)>4
           est=resize_vector(mdl.(vname),mdl.conf.bins)';
       else
           est=y*0;
       end
       err=sum((est-y).^2);  
    end

    function err=fitfcn15(p)
       p{1}=id;
       mdl.load_param(p);
       mdl.run();
       if length(mdl.xpeaks)>4
           est=resize_vector(mdl.(vname),mdl.conf.bins)';
       else
           est=y*0;
       end
       err=sum((est-y).^2); 
    end

    if mdl.stype == 1
        if isempty(initguess), initguess=cell2mat(mdl.params); end
        [x,fval,exitFlag,output] = simulannealbnd(@fitfcn1,initguess)
        pfit=num2cell(x);        
        if do_plot, mdl.plot_trfit(tr,h,pfit,1); end
    elseif mdl.stype == 1.5
        if isempty(initguess), initguess=cell2mat(mdl.params(2:end)); end
        [x,fval,exitFlag,output] = simulannealbnd(@fitfcn15,initguess)
        pfit=num2cell(x);        
        if do_plot, mdl.plot_trfit(tr,h,pfit,1); end
    else
        pfit={};
    end
    
end