function tr = concatenate(obj)
    ds=obj.data_set;
    if obj.unimanual==0
        for idx1=1:obj.size(1)
            for idx2=1:obj.size(2)
                tr=ds{idx1,idx2,1}.copy();
                %Paste trials around maximum values
                for rep=2:obj.size(3)-1
                    tr.concatenate(ds{idx1,idx2,rep});
                end
                tr.vfL.pc = (ds{idx1,idx2,1}.vfL.pc+ds{idx1,idx2,2}.vfL.pc+ds{idx1,idx2,3}.vfL.pc)/3;
                tr.vfR.pc = (ds{idx1,idx2,1}.vfR.pc+ds{idx1,idx2,2}.vfR.pc+ds{idx1,idx2,3}.vfR.pc)/3;
                % Add concatenated trial to DS cell array
                tr.set_concatenated();
                obj.data_set{idx1,idx2,end}=tr;
            end
        end
    else
        for idx1=1:obj.size(1)
            tr=ds{idx1,1}.copy();
            %Paste trials around maximum values
            for rep=2:obj.size(2)-1
                tr.concatenate(ds{idx1,rep});
            end
            tr.vf.pc = (ds{idx1,1}.vf.pc+ds{idx1,2}.vf.pc+ds{idx1,3}.vf.pc)/3;
            % Add concatenated trial to DS cell array
            tr.set_concatenated();
            obj.data_set{idx1,end}=tr;
        end
    end
end
