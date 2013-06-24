function get_trial_vf(obj)
    %Get Unfiltered vectors
    [obj.vectors_unfiltered_, xo, ~]=obj.KMcoef_2D(obj.xo,obj.pc,1/obj.conf.fs,[1,2]);
    obj.vectors_unfiltered_{end+1} = xo;
    %Fit vector field to polinomial functions
    if obj.conf.fitorder>0
        obj.vectors_{1}=obj.KM_Fit(obj.xo,obj.vectors_unfiltered_,1);
        obj.vectors_{2}=obj.KM_Fit(obj.xo,obj.vectors_unfiltered_,2);
    end
    %Get  vector angles
    absAngles = atan2(obj.vectors{1},obj.vectors{2});
    angDiff = obj.eval_neighbours(absAngles, obj.conf.neighbourhood, @obj.get_maxAngle);
    obj.angles_ = {absAngles, angDiff};

end
