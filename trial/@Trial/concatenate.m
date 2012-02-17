function concatenate(obj,obj2)
    obj.ts.concatenate(obj2.ts);
    if isa(obj.ts,'TimeSeriesBimanual')
        obj.oscL.concatenate(obj2.oscL);
        obj.oscR.concatenate(obj2.oscR);
        obj.vfL.concatenate(obj2.vfL);
        obj.vfR.concatenate(obj2.vfR);
        obj.ls = LockingStrength(obj.ts);
    else
        obj.osc.concatenate(obj2.osc);
        obj.vf.concatenate(obj2.vf);
    end
end



