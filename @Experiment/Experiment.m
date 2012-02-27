classdef Experiment 
   properties
      config
      path
      size
      participants=Participant.empty(10,0)
   end
   
    methods
        
        get_configuration(obj)
        
        plot(obj,parallelMode)
        
        analyze(obj)
        
        save(obj); %Disabled
        
        update_vf(obj);

        %%%%%%%%%%%%%
        % Constructor
        %%%%%%%%%%%%%
        function obj = Experiment(path,parallelMode)
            if nargin==0, path=joinpath(joinpath(getuserdir(),'KINARM'),'data'), end;
            obj.path=path;
            obj.size=size(dir2(obj.path),1);
            if nargin>1
                if parallelMode==1
                    labsConf = findResource(); 
                    if matlabpool('size') == 0
                        matlabpool(labsConf.ClusterSize); 
                    end
                    parfor i=1:obj.size
                        p=Participant(i,obj.path);
                        p.save();
                    end             
                else            
                    for i=1:obj.size
                        p=Participant(i,obj.path);
                        p.save();
                    end
                end         
            end
        end
    end
    
    methods(Static=true)            
        exp=load(); %Disabled
        exp=load_participants(); %Disabled
    end
end
