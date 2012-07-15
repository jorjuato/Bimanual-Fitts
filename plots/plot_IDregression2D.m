function plot_IDregression2D(IDown,IDother,MTown,grp,kk,merge_sessions,pp)
    if nargin<6, merge_sessions=1; end
    if nargin<5, kk='pca';end
    if nargin<4, grp=1;end
    
    sep_figs=1;

    mode=4-length(size(IDown));
    switch mode
        case 1
            if merge_sessions == 1
                if sep_figs==0
                    figure;
                end
                if grp==1
                    for g=1:2
                        if sep_figs==1
                            figure;
                            ax=gca();
                        else
                            ax=subplot(1,2,g);
                        end
                        x=IDown(g,:,:);x=x(x~=0);
                        y=IDother(g,:,:);y=y(y~=0);
                        z=MTown(g,:,:);z=z(z~=0);
                        do_plot(ax,x(:),y(:),z(:),kk);
                    end
                else
                    ax=subplot(1,1,1);
                    x=IDown(:,:,:);x=x(x~=0);
                    y=IDother(:,:,:);y=y(y~=0);
                    z=MTown(:,:,:);z=z(z~=0);
                    do_plot(ax,x,y,z,kk);
                end
            else                
                for s=1:3
                    figure;
                    if grp==1
                        for g=1:2
                            ax=subplot(1,2,g);
                            x=IDown(g,s,:);x=x(x~=0);
                            y=IDother(g,s,:);y=y(y~=0);
                            z=MTown(g,s,:);z=z(z~=0);
                            do_plot(ax,x(:),y(:),z(:),kk);
                        end
                    else
                        ax=subplot(1,1,1);
                        x=IDown(:,s,:);x=x(x~=0);
                        y=IDother(:,s,:);y=y(y~=0);
                        z=MTown(:,s,:);z=z(z~=0);
                        do_plot(ax,x,y,z,kk);
                    end
                end
            end
            
        case 2
            for s=1:3
                figure;
                if grp==1
                    do_plot(subplot(1,1,1),IDown(s,:)',IDother(s,:)',MTown(s,:)',kk);
                else
                    do_plot(subplot(1,1,1),IDown(pp,s,:)',IDother(pp,s,:)',MTown(pp,s,:)',kk);
                end
            end
        case 3
            figure;
            if grp==1
                do_plot(subplot(111),IDown',IDother',MTown',kk);
            else
                do_plot(subplot(111),IDown(pp,:,:)',IDother(pp,:,:)',MTown(pp,:,:)',kk);
            end
        otherwise
            return
    end
end
function do_plot(ax,x,y,z,mode)
    if nargin<5, mode='pca'; end
    switch mode
        case 'pca'
            do_plot_PCA(ax,x,y,z);
        case 'polynfit'
            do_plot_polyfit(ax,x,y,z);
        case 'polynfit_3rd'
            do_plot_polyfit_3rd(ax,x,y,z);
        case 'polynfit_nl'
            do_plot_polyfit_nl(ax,x,y,z);
        case 'polynfit_power'
            x=log2((2.^(1-x))*0.1);
            y=log2((2.^(1-y))*0.1);
            z=log2(z);
            do_plot_polyfit_power(ax,x,y,z);
        case 'polynfit_power1'
            x=log2((2.^(1-x))*0.1);
            y=log2((2.^(1-y))*0.1);
            z=log2(z);
            do_plot_polyfit_power1(ax,x,y,z);
        case 'algebra'
            do_plot_algebra(ax,x,y,z);
        case 'normal'
            do_plot_normal(ax,x,y,z);
        otherwise
            return
    end
end
   
function do_plot_PCA(ax,x,y,z)
    X=[x,y,z];

    [coeff,score,roots] = princomp(X);
    basis = coeff(:,1:2)
    normal = coeff(:,3)

    pctExplained = roots' ./ sum(roots)

    [n,p] = size(X);
    meanX = mean(X,1);
    Xfit = repmat(meanX,n,1) + score(:,1:2)*coeff(:,1:2)';
    residuals = X - Xfit;

    error = abs((X - repmat(meanX,n,1))*normal);
    sse = sum(error.^2)

    [xgrid,ygrid] = meshgrid(linspace(min(X(:,1)),max(X(:,1)),5), ...
                             linspace(min(X(:,2)),max(X(:,2)),5));
    zgrid = (1/normal(3)) .* (meanX*normal - (xgrid.*normal(1) + ygrid.*normal(2)));
    h = mesh(ax,xgrid,ygrid,zgrid,'EdgeColor',[0 0 0],'FaceAlpha',0);

    hold on
    above = (X-repmat(meanX,n,1))*normal < 0;
    below = ~above;
    nabove = sum(above);
    X1 = [X(above,1) Xfit(above,1) nan*ones(nabove,1)];
    X2 = [X(above,2) Xfit(above,2) nan*ones(nabove,1)];
    X3 = [X(above,3) Xfit(above,3) nan*ones(nabove,1)];
    plot3(ax,X1',X2',X3','-', X(above,1),X(above,2),X(above,3),'.', 'Color',[0 .7 0]);
    nbelow = sum(below);
    X1 = [X(below,1) Xfit(below,1) nan*ones(nbelow,1)];
    X2 = [X(below,2) Xfit(below,2) nan*ones(nbelow,1)];
    X3 = [X(below,3) Xfit(below,3) nan*ones(nbelow,1)];
    plot3(ax,X1',X2',X3','-', X(below,1),X(below,2),X(below,3),'.', 'Color',[1 0 0]);

    hold off
    maxlim = max(abs(X(:)))*1.1;
    axis([-maxlim maxlim -maxlim maxlim -maxlim maxlim]);
    axis square
    view(-9,12);

end

function do_plot_polyfit(ax,x,y,z)
    p=polyfitn([x,y],z,'constant u v')
    % Evaluate on a grid and plot:
    [xg,yg]=meshgrid(linspace(min(x),max(x),30), ...
                     linspace(min(y),max(y),20));
    zg = polyvaln(p,[xg(:),yg(:)]);
    surf(ax,xg,yg,reshape(zg,size(xg)));
    hold on
    plot3(ax,x,y,z,'.');
    xlabel('ID Own');
    ylabel('ID Other');
    zlabel('MT');
    hold off
end

function do_plot_polyfit_3rd(ax,x,y,z)
    p=polyfitn([x,y],z,'constant u v v^3')
    % Evaluate on a grid and plot:
    [xg,yg]=meshgrid(linspace(min(x),max(x),30), ...
                     linspace(min(y),max(y),20));
    zg = polyvaln(p,[xg(:),yg(:)]);
    surf(ax,xg,yg,reshape(zg,size(xg)));
    hold on
    plot3(ax,x,y,z,'.');
    xlabel('ID Own');
    ylabel('ID Other');
    zlabel('MT');
    hold off
end

function do_plot_polyfit_nl(ax,x,y,z)
    p=polyfitn([x,y],z,2)
    polyn2sympoly(p)
    % Evaluate on a grid and plot:
    [xg,yg]=meshgrid(linspace(min(x),max(x),30), ...
                     linspace(min(y),max(y),20));
    zg = polyvaln(p,[xg(:),yg(:)]);
    surf(ax,xg,yg,reshape(zg,size(xg)));
    hold on
    plot3(ax,x,y,z,'.');
    xlabel('ID Own');
    ylabel('ID Other');
    zlabel('MT');
    hold off
end

function do_plot_polyfit_power(ax,x,y,z)
    p=polyfitn([x,y],z,'constant u v')
    polyn2sympoly(p)
    
    %Regenerate potencial form
    x=(2.^x);
    y=(2.^y);
    z=2.^z;
    c=p.Coefficients(:);
    c1=2^c(1)
    powerLaw = @(x, y) (c1 * x.^c(2) .* y.^c(3));
    
    % Evaluate on a grid and plot:
    [xg,yg]=meshgrid(linspace(min(x),max(x),30), ...
                     linspace(min(y),max(y),20));
    zg = powerLaw(xg(:),yg(:));
    mesh(ax,xg,yg,reshape(zg,size(xg)));
    hold on
    plot3(ax,x,y,z,'.');
    xlabel('We/A Own');
    ylabel('We/A Other');
    zlabel('MT');
    hold off
end

function do_plot_polyfit_power1(ax,x,y,z)
    p=polyfitn([x,y],z,'constant u')
    polyn2sympoly(p)
    
    %Regenerate potencial form
    x=(2.^x);
    y=(2.^y);
    z=2.^z;
    c=p.Coefficients(:);
    c1=2^c(1)
    powerLaw = @(x,y) (c1 * x.^c(2));
    
    % Evaluate on a grid and plot:
    [xg,yg]=meshgrid(linspace(min(x),max(x),30), ...
                     linspace(min(y),max(y),20));
    zg = powerLaw(xg(:),yg(:));
    mesh(ax,xg,yg,reshape(zg,size(xg)));
    hold on
    plot3(ax,x,y,z,'.');
    xlabel('We/A Own');
    ylabel('We/A Other');
    zlabel('MT');
    hold off
end

function do_plot_algebra(ax,x,y,z)
    Xcolv = x(:); % Make X a column vector
    Ycolv = y(:); % Make Y a column vector
    Zcolv = z(:); % Make Z a column vector
    Const = ones(size(Xcolv)); % Vector of ones for constant term

    Coefficients = [Xcolv Ycolv Const]\Zcolv; % Find the coefficients
    XCoeff = Coefficients(1); % X coefficient
    YCoeff = Coefficients(2); % X coefficient
    CCoeff = Coefficients(3); % constant term
    % Using the above variables, z = XCoeff * x + YCoeff * y + CCoeff

    L=plot3(ax,x,y,z,'ro'); % Plot the original data points
%     set(L,'Markersize',2*get(L,'Markersize')) % Making the circle markers larger
%     set(L,'Markerfacecolor','r') % Filling in the markers
    hold on
    % Generating a regular grid for plotting
    [xx, yy]=meshgrid(linspace(min(x),max(x),30), ...
                      linspace(min(y),max(y),20)); 
    zz = XCoeff * xx + YCoeff * yy + CCoeff;
    surf(ax,xx,yy,zz) % Plotting the surface
    title(sprintf('Plotting plane z=(%f)*x+(%f)*y+(%f)',XCoeff, YCoeff, CCoeff))
end

function do_plot_normal(ax,x,y,z)

end