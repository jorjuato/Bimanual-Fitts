function update_conf(obj,src,evnt)
    if strcmp(evnt.EventName,'PostSet')
        display('updated configuration')
        %Nothing more needed due to on-disk storage. 
        %Conf has to be restored after each load from disk
        for i=1:obj.size
            obj.sessions(i).conf=copy(obj.conf);
        end
    end
end
