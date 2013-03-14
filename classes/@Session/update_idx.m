function update_idx(obj)
    props=properties(obj);
    for i=1:length(props)
        if isa(obj.(props{i}),'Block')
            obj.(props{i}).update_idx();
        end
    end
end
