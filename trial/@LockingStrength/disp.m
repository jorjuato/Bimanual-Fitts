function disp(obj)
    props = properties(obj);
    disp('Displaying properties of object LockingStrength...');
    for i=1:length(props)
        p=props{i};
        if length(obj.(p))==1
            str = sprintf('%s = %f.\n', p, obj.(p));
            disp(str);
        elseif isa(obj.(p),'str')
            str = sprintf('%s = %s.\n', p, obj.(p));
            disp(str);
        end
    end
end
