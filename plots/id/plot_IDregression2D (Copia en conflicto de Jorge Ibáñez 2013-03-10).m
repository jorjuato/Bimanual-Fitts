function plot_IDregression2D(biData,biNames,plot_mode,fit_mode,eff_grp)
    if nargin<5, eff_grp=1;end
    if nargin<4, fit_mode='power1';end
    if nargin<3, plot_mode='grp';end %all,grp,ss,ppXX,grp-ss,ss-grp,ppXX-ss
    if nargin<2, error('need bimanual data and variable names');end    

    %Parse participant related plots
    if strcmp(plot_mode(1:2),'pp')
        if length(plot_mode)==7
            pp=str2double(plot_mode(3:4));
        elseif length(plot_mode)==6
            pp=str2double(plot_mode(3));
        else
            pp=str2double(plot_mode(3:end));
        end
        plot_mode='pp';
    end
    
    %Get data in a suitable form for plotting (a bit of a mess, but works)
    [IDown,IDother,MTown,rho] = get_ID_data(biData,biNames,plot_mode);
    
    switch plot_mode
        case 'all'
            figure
            do_plot(gca(),IDown',IDother',MTown',fit_mode);
        case 'grp'
            figure
            if eff_grp
                %Filter variables
                x=IDown(:);
                y=IDother(:);
                z=MTown(:);
                r=rho(:);
                %Plot it
                idx=r==1;
                ax=subplot(1,2,1);
                do_plot(ax,x(idx),y(idx),z(idx),fit_mode);
                idx=r~=1;
                ax=subplot(1,2,2);
                do_plot(ax,x(idx),y(idx),z(idx),fit_mode);
            else
                for g=1:2
                    ax=subplot(1,2,g);
                    do_plot(ax,IDown(g,:)',IDother(g,:)',MTown(g,:)',fit_mode);
                end
            end
        case 'ss'
            figure;
            for s=1:3
                ax=subplot(1,3,s);
                do_plot(ax,IDown(s,:)',IDother(s,:)',MTown(s,:)',fit_mode);
            end
        case 'pp'
            figure;
            do_plot(gca(),IDown(pp,:)',IDother(pp,:)',MTown(pp,:)',fit_mode);          
        case 'grp-ss'
            for g=1:2
                figure;
                for s=1:3
                    ax=subplot(1,3,s);
                    do_plot(ax,IDown(g,s,:)',IDother(g,s,:)',MTown(g,s,:)',fit_mode);
                end
            end
        case 'ss-grp'
            for s=1:3
                figure;
                for g=1:2
                    ax=subplot(1,2,g);
                    do_plot(ax,IDown(g,s,:)',IDother(g,s,:)',MTown(g,s,:)',fit_mode);
                end
            end            
        case 'pp-ss'
            figure;
            for s=1:3
                ax=subplot(1,3,s);
                do_plot(ax,IDown(pp,s,:)',IDother(pp,s,:)',MTown(pp,s,:)',fit_mode);
            end
        otherwise
            return
    end
end

function do_plot(ax,x,y,z,fit_mode)
    if nargin<5, fit_mode='pca'; end
    switch fit_mode
        case 'pca'
            do_plot_PCA(ax,x,y,z);
        case 'poly'
            do_plot_polynfit(ax,x,y,z);
        case 'poly_3rd'
            do_plot_polynfit_3rd(ax,x,y,z);
        case 'poly_nl'
            do_plot_polynfit_nl(ax,x,y,z);
        case 'power2'
            x=log2((2.^(1-x))*0.1);
            y=log2((2.^(1-y))*0.1);
            z=log2(z);
            do_plot_polynfit_power2(ax,x,y,z);
        case 'power1'
            x=log2((2.^(1-x))*0.1);
            y=log2((2.^(1-y))*0.1);
            z=log2(z);
            do_plot_polynfit_power1(ax,x,y,z);
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

function do_plot_polynfit(ax,x,y,z)
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

function do_plot_polynfit_3rd(ax,x,y,z)
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

function do_plot_polynfit_nl(ax,x,y,z)
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

function do_plot_polynfit_power2(ax,x,y,z)
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

function do_plot_polynfit_power1(ax,x,y,z)
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