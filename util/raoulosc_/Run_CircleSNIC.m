
dt     = .01;
width  = 2*dt;
ncyc   = 20;

W=.5:.2:2;

for w=1:length(W)
    if W(w)<1
        cI=3;
    else
        cI=0;
    end
    disp(sprintf('... omega = %.2g... input strength = %.2g',W(w),cI))

    P      = 10./W(w);      % period of pulsetrain in COMPUTATIONAL TIME UNITS
    bparam = [P,width];
    tspan = (0:dt:ncyc*P);
%     [t,y,I]=solve_CircleSNIC(tspan,pi,W(w),cI,bparam);
%     data(w).x=mod(y,2*pi); data(w).t=t; data(w).I=I;
    solve_CircleSNIC(tspan,pi,W(w),cI,bparam);pause,
end
save(['d:\excitator\circledraw\data\CircleSNICsim'],'data','W')
