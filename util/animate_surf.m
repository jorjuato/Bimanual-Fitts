function animate_surf(m,ranges,axislabels)
hS1=surf(ranges{1},ranges{2},m);
xlabel(axislabels{1});
ylabel(axislabels{2});
zlabel(axislabels{3});
alpha(.11)
%hold on
%hS2=surf(X2,Y2,Z2);
%hold off
%axis([-20 20 -20 20 -20 20]);

for j = 1:length(ranges{2})
    X = ranges{1};
    Y = ranges{2}(1:j);
    Z = m(:,1:j);

    set(hS1,'XData',X,'YData',Y,'ZData',Z); 
    %set(hS2,'XData',X2,'YData',Y2,'ZData',Z2);   
    drawnow;
    %pause(0.05) % this slows things down...
    F(j) = getframe;
end
movie(F,4);


end





%     figure('doublebuffer','on')
%     %zscale = [1:0.01:3]; % scale factor for our surface plot
%     zscale = ranges{3};
%     zs=length(zscale);
%     surface = cell(zs,1);
% 
%     for i = 1:zs
%         surface{i} = zscale(i).*membrane; % cell array of z-values
%     end
% 
%     sh = surf(surface{1}); % surface plot of the first surface
%     %zlim([zscale(1)-0.5 zscale(end)])
%     xlabel(axislabels{1});
%     ylabel(axislabels{2});
%     zlabel(axislabels{3});
%     % animation by changing the values of the surface:
%     for j = 2:zs
%         set(sh,'zdata',surface{j})
%         pause(0.05) % this slows things down...
%     end 
% end