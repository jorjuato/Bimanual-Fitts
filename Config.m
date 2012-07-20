classdef Config < handle
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        %Global properties
        root_path 
        data_path
        save_path
        plot_path
        anal_path
        scripts_path = '/home/jorge/Dropbox/dev/Bimanual-Fitts'
        branch_path = 'rebuilt' % Unique name to identify this specific config
        name=''         %Participant directory name
        number=1        %Session number
        blockpath=''    %Block path
        unimanual=0
        hand=''
        inmemory=0
        parallelMode=1  % 0=no paralellization 
                        % 1=parallelize on participants
                        % 2=parallelize on sessions
        workers=5
        
        %Plotting
        ext='png'
        interactive=0
        relative_plots_mode=1   % 1=
                                % 2=
        replication_ts=4
        plot_onload = 1
        
        %Fetch data
        fs = 1E3
        skip_osc=5
        filter_stds=3
        cutoff=10
        compress_pc=1
        compress_ts=1
        split_analysis=1
        promediate=1
        peak_size=0.05
        
        %LockingStrength properties
        peak_delta=2;
        peak_env=25;
        KLD_bins=20;
        
        %VectorField properties
        neighbourhood = [3,3]
        binnumber = 11
        step = 1
        minValsToComputeCondProb = 2
        use_norm=1
        maxAngle_localenv=0.15
        fitorder=3 
        
        
    end % properties
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (Dependent = true, GetAccess = public)
        plot_participant_path
        plot_learning_path
        plot_session_path
        plot_block_path        
        participants   
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
    
        function participants = get.participants(obj)
            participants = length(dir2(obj.data_path));
        end
        
        function set.participants(obj,val)
            %pass
        end
        
        function plot_participant_path = get.plot_participant_path(obj)
            if ischar(obj.name)
                name=obj.name;
            else
                name=num2str(obj.name,'%03d');
            end
            plot_participant_path = joinpath(obj.plot_path,name);
            %plot_participant_path=obj.plot_path;
        end

        function plot_learning_path = get.plot_learning_path(obj)
            plot_learning_path = joinpath(obj.plot_participant_path,'Learning');
        end
        
        function plot_session_path = get.plot_session_path(obj)
            session_name=strcat('Session',num2str(obj.number));
            plot_session_path = joinpath(obj.plot_participant_path,session_name);
        end
        
        function plot_block_path = get.plot_block_path(obj)
            plot_block_path = joinpath(obj.plot_session_path,obj.blockpath);
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
            obj.anal_path = joinpath(obj.root_path,'anal');
            if ~isempty(obj.branch_path)
                obj.save_path = joinpath(obj.save_path,obj.branch_path);
                obj.plot_path = joinpath(obj.plot_path,obj.branch_path);
                obj.anal_path = joinpath(obj.anal_path,obj.branch_path);
            end
            if ~exist(obj.save_path,'dir'), mkdir(obj.save_path); end     
            if ~exist(obj.plot_path,'dir'), mkdir(obj.plot_path); end
            if ~exist(obj.anal_path,'dir'), mkdir(obj.anal_path); end
            obj.participants = size(dir2(obj.data_path),1);
            if obj.participants==0
               fprintf('No participant data found in %s\n',obj.data_path)
            end
        end
    
        function new = copy(obj)
            filename=strcat('temp',random_string(5));
            save(filename, 'obj');
            Foo = load(filename);
            new = Foo.obj;
            delete(strcat(filename,'.mat'));
        end
        
        function dump_tofile(obj,filename,force)
            if nargin==2 && filename==1 
                force=1;
                filename=[obj.save_path '.conf'];            
            end
            if nargin<2, 
                filename=[obj.save_path '.conf']; 
                force=0;
            end
            
            if exist(filename,'file') && force==0
                error('File already exists, use force=1 to override');
            end                
                
            fd=fopen(filename,'wt');
            props = properties(obj);
            for i=1:length(props)
                fprintf(fd,'%25s\t%-20s\n',props{i},num2str(obj.(props{i})));
            end
            fclose(fd);
        end
        
    end
end
