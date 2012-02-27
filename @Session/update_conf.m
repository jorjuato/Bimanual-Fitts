function update_conf(obj,src,evnt)
    if strcmp(evnt.EventName,'PostSet')
        display('updated configuration')
        %Nothing more needed due to on-disk storage. 
        %Conf has to be restored after each load from disk
        props = properties(obj);
        for i=1:length(props)
            if isa(props{i},'Block')
                obj.(props{i}).conf=copy(obj.conf);
            end
        end
    end
end
