function plot(mdl,run_name,no)
    if nargin<3, no=0; end
    if nargin<2, run_name=''; end
    
    switch run_name
        case ''
           if isempty(mdl.t), mdl.run();end
            mdl.plot_single_ts();
            mdl.plot_single_phsp();
            if mdl.stype >=2
                mdl.plot2(run_name,no)
                mdl.plot3(run_name,no)
            end   
        case 'IC'
            mdl.plot_IC(no);
            if mdl.stype >=2
                mdl.plot2(run_name,no)
                mdl.plot3(run_name,no)
            end 
        case 'param'
            mdl.plot_param(no)
            if mdl.stype >=2
                mdl.plot2(run_name,no)
                mdl.plot3(run_name,no)
            end 
    end
end