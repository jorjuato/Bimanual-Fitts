function [D0,x0,names0,D1,x1,names1]=dimtest(x,binnumber,timestep)
 if nargin==0
    K=1;
    Q=0.1;
    timestep=0.005;
    binnumber=40;
    samplenumber=10^7;
    x=pitchfork_sde(K,Q,samplenumber,timestep,0);
 end
fprintf('1D...\n');
[p,xo,pc]=prob_1D(x,binnumber,1);
[D0,x0,names0]=KMcoef_1D(xo,pc,timestep,[1]);
%
fprintf('2D...\n');
y=gradient(sgolayfilt(x,3,7),timestep);
[p,xo,pc]=prob_2D([x,y],binnumber,1);
[D1,x1,names1]=KMcoef_2D(xo,pc,timestep,[1]);
%
dy=repmat(x1{2},1,length(x1{1}));
df=repmat(gradient(D0{1},x0{1})',length(x1{2}),1).*dy;
%
figure(1); plotKMcoef(x1,{D1{1},D1{2}},names1,3);
figure(2); plotKMcoef(x1,dy,df},names1,3);
figure(3); plotKMcoef(x1,{D1{1}./dy,D1{2}./df},names1,3);
