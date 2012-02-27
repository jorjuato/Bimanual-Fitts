classdef Config < handle
    properties
        %Global properties
        root_path 
        data_path
        save_path
        plot_path
        name=''
        number=1
        blockpath=''
        unimanual=0
        hand=''
        parallelMode=1
        
        
        %Plotting
        ext='png'
        interactive=0
        relative_plots_mode=1
        replication_ts=4
        
        %Fetch data
        skip_osc=5
        filter_stds=2
        
        %LockingStrength properties
        peak_delta=2
        
        %VectorField properties
        neighbourhood = [3,3]
        binnumber = 41
        fs = 1E3
        step = 1
        minValsToComputeCondProb = 11
        use_norm=1
        vf_hand=''
        
    end % properties
    properties (Dependent = true, GetAccess = private)
        plot_participant_path
        plot_learning_path
        plot_session_path
        plot_block_path        
        participants   
    end
    
    methods
    
        function participants = get.participants(obj)
            participants = length(dir2,obj.data_path);
        end
        function set.participants(obj,val)
            
        end
        
        function plot_participant_path = get.plot_participant_path(obj)
            if ischar(obj.name)
                name=obj.name;
            else
                name=num2str(obj.name,'%03d');
            end
            plot_participant_path = joinpath(obj.plot_path,name);
        end

        function plot_learning_path = get.plot_learning_path(obj)
            plot_learning_path = joinpath(obj.plot_participant_path,'Learning');
        end
        
        function plot_session_path = get.plot_session_path(obj)
            session_name=strcat('Session',num2str(obj.number));
            plot_session_path = joinpath(obj.plot_participant_path,session_name);
        end
        
        function plot_block_path = get.plot_block_path(obj)
            plot_block_path = joinpath(obj.plot_session_path,obj.blockname);
        end
        
        
        function obj = Config(root_path)
            if nargin == 0
                obj.root_path = joinpath(getuserdir(),'KINARM');
            else
                obj.root_path = root_path;
            end
            obj.data_path = joinpath(obj.root_path,'data');
            obj.save_path = joinpath(obj.root_path,'save');
            obj.plot_path = joinpath(obj.root_path,'plot');            
            obj.participants = size(dir2(obj.data_path),1);        
        end
    
        function new = copy(obj)
            filename=strcat('temp',random_string(5));
            save(filename, 'obj');
            Foo = load(filename);
            new = Foo.obj;
            delete(strcat(filename,'.mat'));
        end
        
    end
end
