classdef Experiment 
   properties(SetObservable = true)
      conf
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
                parfor i=1:obj.size
                    p=Participant(i,copy(obj.conf));
                    p.save();
                end             
            else            
                for i=1:obj.size
                    p=Participant(i,copy(obj.conf));
                    p.save();
                end
            end
        end
    end
    
    methods(Static=true)            
        exp=load(); %Disabled
        exp=load_participants(); %Disabled
    end
end
