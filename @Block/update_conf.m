function update_conf(obj,src,evnt)
    if nargin<3
        src.blockpath=obj.conf.blockpath;
        src.unimanual=obj.conf.unimanual;
        src.hand=obj.conf.hand;
        obj.conf=src;
    elseif strcmp(evnt.EventName,'PostSet')
        display('updated configuration')
        %Nothing more needed due to on-disk storage. 
        %Conf has to be restored after each load from disk
        if obj.conf.unimanual==1
            [ID, Rep] = obj.size;
            for i=1:ID
                for r=1:Rep
                    obj.data_set{i,r}.update_conf(copy(obj.conf));
                end
            end
        else
            [IDL, IDR, Rep] = obj.size;
            for i=1:IDL
                for j=1:IDR
                    for r=1:Rep
                        obj.data_set{i,j,r}.update_conf(copy(obj.conf));
                    end
                end
            end
        end
    end
end
