function concatenate(obj,obj2)    
    %VectorField concatenation
    %Carefull!!! The third trial is more important to determine weight
    obj.pc = (obj.pc + obj2.pc)./2;
    obj.xo = (obj.xo + obj2.xo)./2;