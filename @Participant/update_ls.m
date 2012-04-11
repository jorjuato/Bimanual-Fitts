function update_vf(obj)
    for i=1:length(obj.sessions)
        obj.sessions(i).update_ls()
    end
end
