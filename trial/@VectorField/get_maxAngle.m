function angleMax = get_maxAngle(a)
    c = floor((size(a)+1)/2);
    ac = a(c(1),c(2));
    angleMax=NaN;
    if isnan(ac), return; end
    for i=1:size(a,1)
        for j=1:size(a,2)
            if isnan(a(i,j)), continue; end
            atmp = abs(ac-a(i,j));
            if atmp > pi
                atmp = 2*pi-atmp;
            end
            if atmp > angleMax || isnan(angleMax)
                angleMax=atmp;
            end
        end
    end
end % get_maxAngle