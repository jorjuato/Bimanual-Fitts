function [Dfit]=KM_Fit(B,D,i)

% chose i for D{i}

fitorder = 3;
bound = 0.01;

[X,Y]=meshgrid(B{1},B{2});

coef{i}=polyfit2d(X,Y,D{i},fitorder);
Dfit=polyval2d(coef{i},X,Y);
coef{i}(find(abs(coef{i})<bound))=0;
j=find(isnan(D{i}));
Dfit(j)=NaN;

if nargout==0
    surf(B{1},B{2},D{i},D{i}/max(D{i}(:)),'FaceColor','interp','EdgeColor','none',...
        'FaceLighting','phong','EdgeLighting','phong',...
        'BackFaceLighting','lit','facealpha',0.5); 
    axis tight;
    hold on;
    mesh(X,Y,Dfit,'facecolor','none','edgecolor',[0.5,0.5,0.5]);
    hold off;
    axis tight;
end
