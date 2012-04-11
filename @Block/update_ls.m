function update_vf(obj)
    DS=obj.data_set;
    if obj.unimanual==1
        [ID, rep] = size(DS);
        for i=1:ID
            for r=1:rep
                DS{i,r}.ls.update();
            end
        end
    else
        [IDL, IDR, rep] = size(DS);
        for i=1:IDL
            for j=1:IDR
                for r=1:rep
                    DS{i,j,r}.ls.update()
                end
            end
        end
    end
end
