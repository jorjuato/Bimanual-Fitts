function concatenate(obj,obj2)
    %Oscillations concatenation
    props = properties(obj);
    for i=1:length(props)
        obj.(props{i}) = [ obj.(props{i}) ; obj2.(props{i}) ];
    end