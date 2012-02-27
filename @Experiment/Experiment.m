classdef Experiment 
   properties(SetObservable = true)
      conf
   end
   
    methods
        
        get_configuration(obj)
        
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
            confListener = addlistener(obj,'conf','PostSet',@(src,evnt)update_conf(obj,src,evnt));
            if nargin>1
                if obj.conf.parallelMode==1
                    labsConf = findResource(); 
                    if matlabpool('size') == 0
                        matlabpool(labsConf.ClusterSize); 
                    end
                    parfor i=1:obj.size
                        p=Participant(i,obj.conf);
                        p.save();
                    end             
                else            
                    for i=1:obj.size
                        p=Participant(i,obj.conf);
                        p.save();
                    end
                end         
            end
        end
        
        function update_conf(obj,src,evnt)
            if strcmp(evnt.EventName,'PostSet')
                display('updated configuration')
                %Nothing more needed due to on-disk storage. 
                %Conf has to be restored after each load from disk
                %for i=1:obj.conf.participants
            end
        end
    end
    
    methods(Static=true)            
        exp=load(); %Disabled
        exp=load_participants(); %Disabled
    end
end
