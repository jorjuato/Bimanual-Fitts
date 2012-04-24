classdef Participant < handle
    properties(SetAccess = private)
        %name
        size
        sessions = Session.empty(7,0);
    end % properties

    properties(SetObservable = true)
        conf
    end
    
    methods
    
        %B = subsref(obj,ref)
        
        concatenate(obj)
        
        plot(obj)
        
        plot_vf(obj,graphPath)
        
        plot_va(obj,graphPath)
            
        plot_learning_oscillations(obj,graphPath)
        
        plot_learning_relative(obj,graphPath)
         
        plot_learning_lockingStrength(obj,graphPath)
        
        plot_learning_vf(obj,graphPath)
        
        update_vf(obj)
        
        update_ls(obj)
        
        update_idx(obj)
        
        save(obj)
        
        new = copy(obj)
        
        update_conf(obj,src,evnt)
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = Participant(name,conf)
            if nargin<2, conf=Config(); end            
            obj.conf=conf;
            if nargin == 0
                obj.size = size(obj.sessions);
            else
                if ~isa(name,'str')
                    name=strcat('participant',num2str(name,'%03d'));
                end
                obj.conf.name=name;
                subject_dir = getSubjectDir(conf.name,obj.conf.data_path);
                s = dir2(subject_dir)
                
                if obj.conf.parallelMode==2
                    labsConf = findResource(); 
                    if matlabpool('size') == 0
                        matlabpool(labsConf.ClusterSize); 
                    end
                    confPar=copy(obj.conf);
                    sessions=Session.empty(7,0);
                    parfor i=1:length(s)
                        conf=copy(confPar);
                        conf.number = i;
                        session_path = joinpath(subject_dir,s(i).name)
                        sessions(i) = Session(session_path,conf);
                    end
                    obj.sessions=sessions;
                else
                    for i=1:length(s)
                        conf=copy(obj.conf);
                        conf.number = i;
                        session_path = joinpath(subject_dir,s(i).name);
                        obj.sessions(i) = Session(session_path,conf);
                    end
                end
                obj.size = length(obj.sessions);
                confListener = addlistener(obj,'conf','PostSet',@(src,evnt)update_conf(obj,src,evnt));
            end
        end        
    end % methods
    
        
    methods(Static=true)          
        part=load(p,conf);
    end
end% classdef
