function concatenate(obj,obj2)
    obj.ts.concatenate(obj2.ts);
    obj.osc.concatenate(obj2.osc);
    obj.vf.concatenate(obj2.vf);
    obj.ls = LockingStrength(obj.ts);



