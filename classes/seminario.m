function models = seminario(mdlsfile)
%Setup function flags
if isempty(mdlsfile)
    do_pause=0;
    do_plot=do_pause;
    do_simulate=1;
else
    obj=load(mdlsfile);
    [m0,m05,m1,m2]=obj.mdls{:};
    do_pause=0  ;
    do_plot=1;
    do_simulate=0;
end

%Simplest model
if do_simulate
    m0=Model(0);
end
m0.params{2}=1;
m0.run()
m0.params{2}=0;
if do_plot, plot(m0); end
if do_pause, pause; end
%
m0.params{1}=1.2;
m0.params{2}=1;
if do_plot, plot(m0); end
if do_pause, pause; end
%
m0.params{1}=0.9;
if do_plot, plot(m0); end
if do_pause, pause; end
%
m0.params{1}=1.2;
if do_simulate
    m0.runby_IC(-1:0.3:1)
    if do_plot, plot(m0,'IC'); end
    if do_pause, pause; end
else
    if do_plot, plot(m0,'IC',1); end
    if do_pause, pause; end
end
%
if do_plot
    m0.plot_param_omega4D({'omega','a'},{1:0.25:4,0.5:0.25:1.5});
end
if do_pause, pause; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if do_simulate
    m05=Model(0.5);
end
m05.params{3}=0;
if do_plot, plot(m05); end
if do_pause, pause; end
%
if do_plot
    m05.plot_param_omega4D({'omega','a'},{1:0.25:4,0.5:0.25:1.5});
end
if do_pause, pause; end
%
if do_simulate
    m05.runby_param2({'omega','a'},{1:0.25:4,0.5:0.25:1.5});
    if do_plot
        m05.plot_param_4D('x','_phhist');
        m05.plot_param_4D('v','_phhist');
    end
    if do_pause, pause; end
else
    if do_plot
        m05.plot_param_4D('x','_phhist',1);
        m05.plot_param_4D('v','_phhist',1);
    end
    if do_pause, pause; end  
end
%
m05.params{1}=1.6;
m05.params{2}=1;
if do_plot
    m05.plot_param_omega4D({'c','d'},{0:0.5:pi,0:0.5:pi});
    m05.plot_param_omega4D({'d','c'},{0:0.5:pi,0:0.5:pi});
end
if do_pause, pause; end
%
if do_simulate
    m05.runby_param2({'c','d'},{0:0.5:pi,0:0.5:pi});
    if do_plot
        m05.plot_param_4D('x','_phhist');
        m05.plot_param_4D('v','_phhist');
    end
    if do_pause, pause; end
else
    if do_plot
        m05.plot_param_4D('x','_phhist',2);
        m05.plot_param_4D('v','_phhist',2);
    end
    if do_pause, pause; end  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if do_simulate
    m1=Model(1);
end
m1.params{4}=0;
if do_plot, plot(m1); end
if do_pause, pause; end
%
if do_plot
    m1.plot_param_omega4D({'omega','a'},{1:0.25:4,0.5:0.25:1.5});
end
if do_pause, pause; end
%
if do_simulate
    m1.runby_param2({'omega','a'},{1:0.25:4,0.5:0.25:1.5});
    if do_plot
        m1.plot_param_4D('x','_phhist');
        m1.plot_param_4D('v','_phhist');
    end
    if do_pause, pause; end
else
    if do_plot
        m1.plot_param_4D('x','_phhist',1);
        m1.plot_param_4D('v','_phhist',1);
    end
    if do_pause, pause; end
end
%
m1.params{1}=1.6;
m1.params{2}=1;
if do_plot
    m1.plot_param_omega4D({'c','d'},{0:0.5:pi,0:0.5:pi});
    m1.plot_param_omega4D({'d','c'},{0:0.5:pi,0:0.5:pi});
end
if do_pause, pause; end
%
if do_simulate
    m1.runby_param2({'c','d'},{0:0.5:pi,0:0.5:pi});
    if do_plot
        m1.plot_param_4D('x','_phhist');
        m1.plot_param_4D('v','_phhist');
    end
    if do_pause, pause; end
else
    if do_plot
        m1.plot_param_4D('x','_phhist',2);
        m1.plot_param_4D('v','_phhist',2);
    end
    if do_pause, pause; end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if do_simulate
    m2=Model(2);
end
%m.params{4}=0;
if do_plot, plot(m2); end
if do_pause, pause; end

models={m0,m05,m1,m2};

end