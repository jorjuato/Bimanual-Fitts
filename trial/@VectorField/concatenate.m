function concatenate(obj,obj2)    
    %VectorField concatenation
    %Carefull!!! The third trial is more important to determine weight
    
    obj.pc = (obj.pc + obj2.pc)./2;
    %obj.xo = num2cell(cellfun(@(x,y) sum([x,y],2),obj.xo,obj2.xo)./2);
    [r,c]=size(obj.xo);
    for i=1:r
        for j=1:c
            obj.xo{i,j}=(obj.xo{i,j}+obj2.xo{i,j})/2;
            
        end
    end
end
            
           
