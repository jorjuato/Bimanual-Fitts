function update_ls(obj)
    DS=obj.data_set;
    if obj.conf.unimanual==1
        disp('Nothing to update for Locking Strength variables in unimanual blocks')
    else
        [IDL, IDR, rep] = obj.size{:};
        for i=1:IDL
            for j=1:IDR
                for r=1:rep
                    DS{i,j,r}.ls.update(DS{i,j,r}.ts)
                end
            end
        end
    end
end
