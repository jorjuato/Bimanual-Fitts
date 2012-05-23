function disp(obj)
    props = properties(obj);
    fprintf('\nProperties of object LockingStrength...\n');
    for i=1:length(props)
        p=props{i};
        if length(obj.(p))==1 && ~strcmp(p,'conf')
            str = sprintf('%10s = %2.3f.', p, obj.(p));
            disp(str);
        elseif isa(obj.(p),'str')
            str = sprintf('%10s = %s.', p, obj.(p));
            disp(str);
        end
    end
    fprintf('\n');
end
