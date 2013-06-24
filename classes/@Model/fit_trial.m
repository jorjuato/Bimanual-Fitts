function pfit=fit_trial(mdl,tr,h,initguess,do_plot)
    if nargin<5, do_plot=1; end
    if nargin<4, initguess=[]; end
    if nargin<3, h='';end
        
    y=tr.ts.([h,'omega_phhist']);
    id=tr.info.([h,'ID']);
    mdl.conf.bins=length(y);
    x=linspace(pi,-pi,length(y)); 
    opts = statset('nlinfit');
    %opts.Robust='on';
    %opts.RobustWgtFun = 'bisquare';
    opts.MaxIter=10000;
    
    if mdl.stype == 1
        fitfcn= @(p, x) -(p(1) + p(2)*sin(2*(x-p(4))+p(5)) + p(3)*cos(4*(x-p(4))));
        if isempty(initguess), initguess=cell2mat(mdl.params); end
        fit = nlinfit(x, y', fitfcn, initguess, opts, 'ErrorModel','combined'); %Least squares curve fit to inline        
        pfit=num2cell(fit);
        if do_plot, mdl.plot_trfit(tr,h,pfit,1); end
    elseif mdl.stype == 1.1
        fitfcn= @(p, x) -(p(1) + p(2)*cos(2*(x-p(4))+p(5)) + p(3)*cos(4*(x-p(4))));
        if isempty(initguess), initguess=cell2mat(mdl.params); end
        fit = nlinfit(x, y', fitfcn, initguess, opts, 'ErrorModel','combined'); %Least squares curve fit to inline        
        pfit=num2cell(fit);
        if do_plot, mdl.plot_trfit(tr,h,pfit,1); end        
    elseif mdl.stype == 1.2
        fitfcn= @(p, x) -(p(1) + p(2)*cos(2*(x-p(4))+p(5)) + p(3)*cos(4*(x-p(4))));
        if isempty(initguess), initguess=cell2mat(mdl.params); end
        fit = nlinfit(x, y', fitfcn, initguess, opts, 'ErrorModel','combined'); %Least squares curve fit to inline        
        pfit=num2cell(fit);
        if do_plot, mdl.plot_trfit(tr,h,pfit,1); end          
    elseif mdl.stype == 1.3        
        fitfcn= @(p, x) -(p(1) + p(2)*sin(2*(x-p(4))+p(5)) + p(3)*sin(4*(x-p(4))));
        if isempty(initguess), initguess=cell2mat(mdl.params); end
        fit = nlinfit(x, y', fitfcn, initguess, opts, 'ErrorModel','combined'); %Least squares curve fit to inline
        pfit=num2cell(fit);
        if do_plot, mdl.plot_trfit(tr,h,pfit,1); end
    elseif mdl.stype == 1.4
        return
%         fitfcn= @(p, x) -(p(1) + p(2)*cos(2*(x-p(4))+p(5)) + p(3)*cos(4*(x-p(4))));
%         if isempty(initguess), initguess=cell2mat(mdl.params); end
%         fit = nlinfit(x, y', fitfcn, initguess, opts, 'ErrorModel','combined'); %Least squares curve fit to inline
%         pfit=num2cell(fit);
%         if do_plot, mdl.plot_trfit(tr,h,pfit,1); end        
    elseif mdl.stype == 1.5
        fitfcn= @(p, x) -(p(1)/id + p(2)/id*sin(2*(x-p(4))+p(5)) + p(3)*id*cos(4*(x-p(4))));
        if isempty(initguess), initguess=cell2mat(mdl.params(2:end)); end
        fit = nlinfit(x, y', fitfcn, initguess, opts, 'ErrorModel','combined'); %Least squares curve fit to inline
        pfit=num2cell([id,fit]);
        if do_plot, mdl.plot_trfit(tr,h,pfit,1); end
    elseif mdl.stype == 1.6
        fitfcn= @(p, x) -(p(1) + p(2)*sin(2*(x-p(4))) + p(3)*cos(4*(x+p(4))));
        if isempty(initguess), initguess=cell2mat(mdl.params); end
        fit = nlinfit(x, y', fitfcn, initguess, opts, 'ErrorModel','combined'); %Least squares curve fit to inline        
        pfit=num2cell(fit);
        if do_plot, mdl.plot_trfit(tr,h,pfit,1); end        
    elseif mdl.stype == 1.7
        fitfcn= @(p, x) -( p(1) + p(2)*sin(2*x-p(4)) + p(3)*cos(4*x) );
        if isempty(initguess), initguess=cell2mat(mdl.params); end
        fit = nlinfit(x, y', fitfcn, initguess, opts, 'ErrorModel','combined'); %Least squares curve fit to inline        
        pfit=num2cell(fit);
        if do_plot, mdl.plot_trfit(tr,h,pfit,1); end           
    else
        pfit={};
    end
end