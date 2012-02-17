classdef Participant
    properties(SetAccess = private)
        name
        size
        sessions = Session.empty(7,0);
        path = pwd;
    end % properties

    methods
    
        %B = subsref(obj,ref)
        
        concatenate(obj)
        
        plot(obj,graphPath,ext)
            
        plot_learning_oscillations(obj,graphPath,ext);
        
        plot_learning_relative(obj,mode,graphPath,ext);
         
        plot_learning_lockingStrength(obj,graphPath,ext);
        
        plot_learning_vf(obj,graphPath,ext);
        
        save(obj);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Constructor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = Participant(name)
            if nargin == 0
                obj.path = pwd;
                obj.size = size(obj.sessions);
            else
                if ~isa(name,'str')
                    name=strcat('participant',num2str(name,'%03d'));
                end
                obj.name=name;
                subject_dir = getSubjectDir(obj.name);
                s = dir2(subject_dir);
                for i=1:length(s)
                    obj.sessions(i) = Session(joinpath(subject_dir,s(i).name));
                end
                obj.size = length(obj.sessions);
            end
        end        
    end % methods
    
        
    methods(Static=true)            
        part=load(p);    
    end
end% classdef
