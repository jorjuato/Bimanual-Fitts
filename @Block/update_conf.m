function update_conf(obj,src,evnt)
    %if nargin<3
        %src.blockpath=obj.conf.blockpath;
        %src.unimanual=obj.conf.unimanual;
        %src.hand=obj.conf.hand;
        obj.conf=src;
        obj.size=size(obj.data_set);
    %elseif strcmp(evnt.EventName,'PostSet')
        display('updated Block configuration')
        %Nothing more needed due to on-disk storage. 
        %Conf has to be restored after each load from disk
        if length(obj.size)==2
            obj.conf.unimanual=1;
        %if obj.conf.unimanual==1
            %[ID, Rep] = obj.size;
            [ID, Rep] = size(obj.data_set);
            for i=1:ID
                for r=1:Rep
                    obj.data_set{i,r}.update_conf(copy(obj.conf));
                end
            end
        else
            obj.conf.unimanual=0;
            %[IDL, IDR, Rep] = obj.size;
            [IDL, IDR, Rep] = size(obj.data_set);
            for i=1:IDL
                for j=1:IDR
                    for r=1:Rep
                        obj.data_set{i,j,r}.update_conf(copy(obj.conf));
                    end
                end
            end
        end
    %end
end
