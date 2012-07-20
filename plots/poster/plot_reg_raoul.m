
function plot_reg_raoul(A)
[s,l,r,~]=size(A);   
colors={'r+-','g+-','b+-';'ro-','go-','bo-'};
figure; 
hold on;
for ss=1:s
    for idl=1:l
        plot(A(ss,:,idl,2),colors{idl,ss});
    end
    legend();
end
hold off     
end