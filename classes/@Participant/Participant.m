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
    
        B = subsref(obj,sth,ref)
        
        concatenate(obj)
        
        plot(obj)
        
        %plot_vf(obj,graphPath)
        
        plot_va(obj,graphPath)
            
        plot_learning_oscillations(obj,graphPath)
        
        plot_learning_relative(obj,graphPath)
         
        plot_learning_lockingStrength(obj,graphPath)
        
        %plot_learning_vf(obj,graphPath)
        
        update_vf(obj)
        
        update_ls(obj)
        
        update_idx(obj)
        
        save(obj)
        
        new = copy(obj)
        
        update_conf(obj,src,evnt)
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = Participant(name_,conf)
            if nargin<2, conf=Config(); end            
            obj.conf=conf;
            if nargin == 0
                obj.size = size(obj.sessions);
            else
                if ~isa(name_,'str')
                    name=strcat('participant',num2str(name_,'%03d'));
                end
                out_files=dir2(obj.conf.save_path);
                if any(strcmp({out_files.name},[name '.mat']))
                    obj=Participant.load(name_,conf);
                else
                    obj.conf.name=name;
                    subject_dir = getSubjectDir(conf.name,obj.conf.data_path);
                    s = dir2(subject_dir);

                    if obj.conf.parallelMode==2 %fucking broken!!
                        labsConf = findResource(); 
                        if matlabpool('size') == 0
                            %matlabpool(labsConf.ClusterSize);
                            matlabpool(obj.conf.workers)
                            %matlabpool local 2;
                        end
                        confPar=copy(obj.conf);
                        sessions=Session.empty(7,0);
                        for i=1:length(s)
                            session_paths{i} = joinpath(subject_dir,s(i).name);
                        end                        
                        %session_paths{:}
                        parfor i=1:length(s)
                            conf=copy(confPar);
                            conf.number = i;   
                            %session_paths{i}
                            sessions(i) = Session(session_paths{i},conf);
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
