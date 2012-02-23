classdef Experiment 
   properties
      config
      participants=Participant.empty(10,0)
   end
   
    methods
        
        get_configuration(obj)
        
        plot(obj,graphPath,rootname,ext)
        
        analyze(obj)
        
        save(obj);
        
        update_vf(obj);

        %%%%%%%%%%%%%
        % Constructor
        %%%%%%%%%%%%%
        function obj = Experiment(parallelMode)
            if nargin>0            
                %obj.get_configuration()
                
                if parallelMode==1
                    labsConf = findResource(); 
                    if matlabpool('size') == 0
                        matlabpool(labsConf.ClusterSize); 
                    end
                    parfor p=1:size(obj.participants,1)
                        part=Participant(p);
                        part.save();
                    end
                    for p=1:size(obj.participants,1)
                        obj.participants(p)=Participant().load(p);
                    end                
                else            
                    for p=1:size(obj.participants,1)
                        obj.participants(p)=Participant(p);
                    end
                end
                obj.save();            
            end
        end
    end
    
    methods(Static=true)            
        exp=load();
        exp=load_participants();
    end
end
