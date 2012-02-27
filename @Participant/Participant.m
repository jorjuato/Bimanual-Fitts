classdef Participant
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
        
        concatenate(obj);
        
        plot(obj);
        
        plot_vf(obj);
        
        plot_va(obj);
            
        plot_learning_oscillations(obj);
        
        plot_learning_relative(obj);
         
        plot_learning_lockingStrength(obj);
        
        plot_learning_vf(obj);
        
        update_vf(obj);
        
        save(obj);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = Participant(name,conf)
            if nargin<2, conf=Config(); end

            if nargin == 0
                obj.size = size(obj.sessions);
            else
                if ~isa(name,'str')
                    name=strcat('participant',num2str(name,'%03d'));
                end
                conf.name=name;
                subject_dir = getSubjectDir(conf.name,conf.data_path);
                s = dir2(subject_dir);
                for i=1:length(s)
                    conf.number = i;
                    session_path = joinpath(subject_dir,s(i).name);
                    obj.sessions(i) = Session(session_path,copy(conf));
                end
                obj.size = length(obj.sessions);
                obj.conf = copy(conf);
                confListener = addlistener(obj,'conf','PostSet',@(src,evnt)update_conf(obj,src,evnt));
            end
        end        
    end % methods
    
        
    methods(Static=true)          
        part=load(p,conf);
    end
end% classdef
