function ang=get_VF_circularity(vf)
    rot90=[0,1;-1,0];
    rot_90=[0,-1;1,0];
    vfx=vf.vectors{1};
    vfy=vf.vectors{2};
    c=vf.xo{1};
    ang=zeros(length(c))*nan;
    for i=1:length(c)
        for j=1:length(c)
            x=vfx(i,j);
            y=vfy(i,j);
            if ~isnan(x) & ~isnan(y)
                v=[x;y];
                r=[c(i);c(j)];
                n1=rot90*r;
                n2=rot_90*r;
                a1=atan2(abs(det([v,n1])),dot(v,n1));
                a2=atan2(abs(det([v,n2])),dot(v,n2));
                if a1<a2
                    ang(i,j)=a1;
                else
                    ang(i,j)=a2;
                end
            end
        end
    end
end

