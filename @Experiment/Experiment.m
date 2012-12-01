classdef Experiment < handle %dynamicprops
   properties(SetObservable = true)
      conf      
   end
   properties (SetAccess = private)
    participants=Participant.empty(10,0);
    size = 10
   end
    methods
        
        plot(obj)
        
        analyze(obj)
        
        save(obj); %Disabled
        
        new = copy(obj);
        
        update_vf(obj);
        
        B = subsref(obj,sth,ref)

        %%%%%%%%%%%%%
        % Constructor
        %%%%%%%%%%%%%
        function obj = Experiment(conf)
            if nargin==0, conf=Config(); end;
            obj.conf = conf;
            %Check if outdir contains no participantXXX.mat file
            %And load all by default in this case
            
            out_files=dir2(obj.conf.save_path);
            if isempty(out_files)
                obj.get_results();
            elseif obj.conf.inmemory==1
                if strcmp(out_files(1).name,'participant001.mat') 
                    obj=obj.load_participants(obj);
                elseif strcmp(out_files(1).name,'experiment.mat')
                    obj=obj.load(obj);
                else
                    obj.get_results();
                end
            end    
        end
        
        function get_results(obj)
            obj.conf.dump_tofile(1);
            obj.save_scripts();
            if ~exist(obj.conf.save_path,'dir')
                mkdir(obj.conf.save_path); 
            end   
            if obj.conf.parallelMode==1
                labsConf = findResource(); 
                if matlabpool('size') == 0
                    %matlabpool(labsConf.ClusterSize); 
                    matlabpool(obj.conf.workers)
                    %matlabpool local 2;
                end
                if obj.conf.inmemory
                    participants=Participant.empty(10,0);
                end
                parfor i=1:10
                    p=Participant(i,copy(obj.conf));
                    p.save();
                    if obj.conf.inmemory
                        participants(i)=copy(p);
                    end
                    if obj.conf.plot_onload ==1
                        plot(p);
                    end
                end             
            else            
                for i=1:obj.size
                    p=Participant(i,copy(obj.conf));
                    p.save();
                    if obj.conf.inmemory
                        participants(i)=p;
                    end
                end
            end
            if obj.conf.inmemory
                obj.participants=participants;
            end
        end
        
        function save_scripts(obj)
            files_ls=ls(obj.conf.scripts_path);
            ftmp=regexp(files_ls,'\s','split');
            files=ftmp(1:2:end);
            save_path=obj.conf.save_path(1:end-length(obj.conf.branch_path))
            outname=joinpath(save_path,['scripts_' obj.conf.branch_path '.zip']);
            zip(outname,files,obj.conf.scripts_path);
        end
    end
    
    
    methods(Static=true)            
        exp=load(obj); %Disabled
        exp=load_participants(obj); %Disabled
    end
end
