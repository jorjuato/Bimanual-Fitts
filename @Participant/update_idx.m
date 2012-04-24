function update_idx(obj)
    for i=1:length(obj.sessions)
        obj.sessions(i).update_idx()
    end
end
