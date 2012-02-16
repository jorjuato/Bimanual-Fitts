function test_filter(xraw,vraw)
nyqfreq = [500];%,1000];
cuttoff = [20];
filters = setprod(nyqfreq,cuttoff);
figure();
ax1=subplot(2,1,1);
hold on;
plot(ax1,xraw);    
ax2=subplot(2,1,2);
hold on;
plot(ax2,vraw);
length(filters)
for i=1:length(filters)    
    plot(ax1,filterdata(xraw,filters(i,1),filters(i,2)),'Color',getColor(i+1));
    plot(ax2,filterdata(vraw,filters(i,1),filters(i,2)),'Color',getColor(i+1));    
end

end

function xf = filterdata(x,nyqfreq, cutoff)
    %Raoul's version
    if nargin<3, nyqfreq=1000; end
    if nargin<2, cutoff=12; end
    
    %4th order Butter low-pass filter
    [b,a]=butter(4,cutoff/nyqfreq,'low');
    xf = filtfilt(b,a,x);
end

function color = getColor(n)
colorOrder = ...
 [ 0 0 1 % 1 BLUE
    0 1 0 % 2 GREEN (pale)
    1 0 0 % 3 RED
    0 1 1 % 4 CYAN
    1 0 1 % 5 MAGENTA (pale)
    1 1 0 % 6 YELLOW (pale)
    0 0 0 % 7 BLACK
    0 0.75 0.75 % 8 TURQUOISE
    0 0.5 0 % 9 GREEN (dark)
    0.75 0.75 0 % 10 YELLOW (dark)
    1 0.50 0.25 % 11 ORANGE
    0.75 0 0.75 % 12 MAGENTA (dark)
    0.7 0.7 0.7 % 13 GREY
    0.8 0.7 0.6 % 14 BROWN (pale)
    0.6 0.5 0.4 ]; % 15 BROWN (dark)
color = colorOrder(n,:);
end