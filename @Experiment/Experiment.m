classdef Experiment < dynamicprops
   properties(SetObservable = true)
      conf
      participants=Participant.empty(10,0);
   end

    methods
        
        plot(obj)
        
        analyze(obj)
        
        save(obj); %Disabled
        
        update_vf(obj);

        %%%%%%%%%%%%%
        % Constructor
        %%%%%%%%%%%%%
        function obj = Experiment(conf)
            if nargin==0, conf=Config(); end;
            obj.conf = conf;
            %Check if outdir contains no participantXXX.mat file
            %And load all by default in this case
        end
        
        function get_results(obj)
            if obj.conf.parallelMode==1
                labsConf = findResource(); 
                if matlabpool('size') == 0
                    matlabpool(labsConf.ClusterSize); 
                end
                if obj.conf.inmemory
                    participants=Participant.empty(10,0);
                end
                parfor i=1:obj.size
                    p=Participant(i,copy(obj.conf));
                    p.save();
                    if obj.conf.inmemory
                        participants(i)=p;
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
        exp=load(); %Disabled
        exp=load_participants(); %Disabled
    end
end
