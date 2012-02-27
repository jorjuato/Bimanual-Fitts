classdef Participant
    properties(SetAccess = private)
        name
        size
        sessions = Session.empty(7,0);
        path = pwd;
        data_path;
    end % properties

    methods
    
        %B = subsref(obj,ref)
        
        concatenate(obj);
        
        plot(obj,graphPath,ext);
        
        plot_vf(obj,graphPath,ext);
        
        plot_va(obj,graphPath,ext);
            
        plot_learning_oscillations(obj,graphPath,ext);
        
        plot_learning_relative(obj,mode,graphPath,ext);
         
        plot_learning_lockingStrength(obj,graphPath,ext);
        
        plot_learning_vf(obj,graphPath,ext);
        
        update_vf(obj);
        
        save(obj);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = Participant(name,path)
            if nargin<2, path=joinpath(getuserdir(),'KINARM'); end
            
            obj.path=path;
            obj.data_path=joinpath(obj.path,'data');
            if nargin == 0
                obj.size = size(obj.sessions);
            else
                if ~isa(name,'str')
                    name=strcat('participant',num2str(name,'%03d'));
                end
                obj.name=name;
                subject_dir = getSubjectDir(obj.name,obj.data_path);
                s = dir2(subject_dir);
                for i=1:length(s)
                    obj.sessions(i) = Session(joinpath(subject_dir,s(i).name));
                end
                obj.size = length(obj.sessions);
            end
        end        
    end % methods
    
        
    methods(Static=true)            
        part=load(p,path);    
    end
end% classdef
