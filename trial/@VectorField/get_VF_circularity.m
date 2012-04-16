function ang=get_VF_circularity(vf, mode)
    if nargin==1, mode=1; end
    
    if mode==1
        ang=get_VF_circularity_1(vf);
    elseif mode==2
        ang=get_VF_circularity_2(vf);
    elseif mode==3
        ang=get_VF_circularity_3(vf);
    elseif mode==4
        ang=get_VF_circularity_4(vf);
    else
        dispaly(['Mode',num2str(mode),' not implemented!'])
    
end

function ang=get_VF_circularity_1(vf)
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

function ang=get_VF_circularity_2(vf)
    %This method imposes a circle of R=1 and center=(0,0)
    vx=vf.vectors{1};
    [X,Y]=meshgrid(vf.xo{1},vf.xo{2});
    [theta,R] = cart2pol(X(~isnan(vx)),Y(~isnan(vx)));
    ang=1/(1-mean(R));
end

function ang=get_VF_circularity_3(vf)
    %Broken!! Need to get a meaningful fittype yet...
    %see for reference 
    %http://www.mathworks.com/matlabcentral/newsreader/view_thread/290120
    vx=vf.vectors{1};
    [X,Y]=meshgrid(vf.xo{1},vf.xo{2});
    xdata=X(~isnan(vx));
    ydata=Y(~isnan(vx));
    f = fittype('(2*x0-2*x)*x_c + (2*y0-2*y)*y_c = -((x^2-x0^2)+(y^2-yo^2))'); 
    [fitc gof] = fit(xdata,ydata,f,'StartPoint',[1 1]);
    fdata = feval(fit_circ,xdata); 
    I = abs(fdata - ydata) > 1.5*std(ydata);     
end


