function update_conf(obj,src,evnt)
    %if nargin<3
        %src.number=obj.conf.number;
        obj.conf=src;
    %else
        %if strcmp(evnt.EventName,'PostSet')
            display('updated Session configuration')
            %Nothing more needed due to on-disk storage. 
            %Conf has to be restored after each load from disk
            props = properties(obj);
            for i=1:length(props)
                if isa(obj.(props{i}),'Block')
                    obj.(props{i}).update_conf(copy(obj.conf));
                end
            end
        %end
    %end
end
