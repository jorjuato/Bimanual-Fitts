function update_vf(obj)
    DS=obj.data_set;
    if obj.unimanual==1
        [ID, rep] = obj.size{:};
        for i=1:ID
            for r=1:rep-1
                DS{i,r}.vf=VectorField(DS{i,r}.ts);
            end
            DS{i,end}.vf.pc = (DS{i,1}.vf.pc+DS{i,2}.vf.pc+DS{i,3}.vf.pc)/3;
        end
    else
        [IDL, IDR, rep] = obj.size{:};
        for i=1:IDL
            for j=1:IDR
                for r=1:rep-1
                    DS{i,j,r}.vfL=VectorField(DS{i,j,r}.ts,'L');
                    DS{i,j,r}.vfR=VectorField(DS{i,j,r}.ts,'R');
                end
            DS{i,j,end}.vfL.pc = (DS{i,j,1}.vfL.pc+DS{i,j,2}.vfL.pc+DS{i,j,3}.vfL.pc)/3;
            DS{i,j,end}.vfR.pc = (DS{i,j,1}.vfR.pc+DS{i,j,2}.vfR.pc+DS{i,j,3}.vfR.pc)/3;
            end
        end
    end
end
