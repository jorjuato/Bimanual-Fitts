classdef Experiment < dynamicprops
   properties(SetObservable = true)
      conf
      participants=Participant.empty(10,0);
   end
   properties
    size =10
   end
    methods
        
        plot(obj)
        
        analyze(obj)
        
        save(obj); %Disabled
        
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
            if obj.conf.parallelMode==1
                labsConf = findResource(); 
                if matlabpool('size') == 0
                    %matlabpool(labsConf.ClusterSize); 
                    matlabpool local 5;
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
    end
    
    methods(Static=true)            
        exp=load(obj); %Disabled
        exp=load_participants(obj); %Disabled
    end
end
