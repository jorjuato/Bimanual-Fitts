function update_idx(obj)
    DS=obj.data_set;
    if obj.conf.unimanual==1
        [ID, rep] = size(DS);
        for i=1:ID
            for r=1:rep-1
                DS{i,r}.update_idx();
            end
        end
    else
        [IDL, IDR, rep] = size(DS);
        for i=1:IDL
            for j=1:IDR
                for r=1:rep-1
                    DS{i,j,r}.update_idx();
                end
            end
        end
    end
end
