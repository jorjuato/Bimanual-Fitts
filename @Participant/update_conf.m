function update_conf(obj,src,evnt)
    if nargin<3
        src.name=obj.conf.name;
        obj.conf=src;
    elseif strcmp(evnt.EventName,'PostSet')
        display('updated Participant configuration')
        %Nothing more needed due to on-disk storage
        %Conf has to be restored after each load from disk
        for i=1:obj.size
            obj.sessions(i).update_conf(copy(obj.conf));
        end
    end
end
