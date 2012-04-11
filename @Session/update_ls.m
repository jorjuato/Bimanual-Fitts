function update_ls(obj)
    props=properties(obj);
    for i=1:length(props)
        if isa(obj.(props{i}),'Block')
            obj.(props{i}).update_ls();
        end
    end
end
