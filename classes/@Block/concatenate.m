function tr = concatenate(obj)
    ds=obj.data_set;
    if obj.conf.unimanual==0
        [IDL,IDR,RE]=obj.size{:};
        for l=1:IDL
            for r=1:IDR
                ts=ds{l,r,1}.ts.copy();
                %Paste time series 
                for rep=2:RE-1
                    ts.concatenate(ds{l,r,rep}.ts);
                end
                %Create new Trial instance with concatenated ts
                tr=Trial(ts);
                %Copy vector field objects
                tr.vfL=ds{l,r,1}.vfL.copy();
                tr.vfR=ds{l,r,1}.vfR.copy();
                %Concatenate conditional probability matrices
                tr.vfL.pc = (ds{l,r,1}.vfL.pc+ds{l,r,2}.vfL.pc+ds{l,r,3}.vfL.pc)/3;
                tr.vfR.pc = (ds{l,r,1}.vfR.pc+ds{l,r,2}.vfR.pc+ds{l,r,3}.vfR.pc)/3;
                if tr.vfL.conf.store_vf==1
                    tr.vfL.get_trial_vf();
                    tr.vfR.get_trial_vf();
                end
                % Add concatenated trial to DS cell array
                tr.set_concatenated();
                obj.data_set{l,r,end}=tr;
            end
        end
    else
        [ID,RE]=obj.size{:};
        for i=1:ID
            ts=ds{i,1}.ts.copy();
            %Paste trials around maximum values
            for rep=2:RE-1
                ts.concatenate(ds{i,rep}.ts);
            end
            %Create new Trial instance with the concatenated time serie
            tr=Trial(ts);
            %Copy vector field objects
            tr.vf=ds{i,1}.vf.copy();            
            %Concatenate conditional probability matrices
            tr.vf.pc = (ds{i,1}.vf.pc+ds{i,2}.vf.pc+ds{i,3}.vf.pc)/3;            
            if tr.vf.conf.store_vf==1
                tr.vf.get_trial_vf();
            end
            % Add concatenated trial to DS cell array
            tr.set_concatenated();
            obj.data_set{i,end}=tr;
        end
    end
end
