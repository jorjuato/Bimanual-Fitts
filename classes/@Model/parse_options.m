function [trs, run_range, run_name, parval] = parse_options(mdl,run_name,no)
if nargin<3, no=0; end
    switch run_name
        case ''
            if isempty(mdl.t), mdl.run();end
            trs={struct( 't',     mdl.t,    'ph',      mdl.ph,...                                                    
                         'ph0',   mdl.IC,   'params',  mdl.params)};
            run_range=1;
            parval=[];
        case 'param'
            if isempty(mdl.pset)
                error('You have to run a parametrization before')
            end
            if no==0
                trs=mdl.pset{end}{4};
                run_name=mdl.pset{end}{1};
                run_range=mdl.pset{end}{2};
                parval=mdl.pset{end}{3};
            else
                trs=mdl.pset{no}{4};
                run_name=mdl.pset{no}{1};
                run_range=mdl.pset{no}{2};                
                parval=mdl.pset{no}{3};
            end
        case 'IC'
            if isempty(mdl.icset)
                error('You have to run an IC simulation before')
            end
            if no==0
                trs=mdl.icset{end}{3};                
                run_range=mdl.pset{end}{1};
                parval=mdl.pset{end}{2};
            else
                trs=mdl.icset{no}{3};                
                run_range=mdl.icset{no}{1};
                parval=mdl.pset{no}{2};
            end            
        otherwise
            error('Run type has to be one of IC|param')
    end
end