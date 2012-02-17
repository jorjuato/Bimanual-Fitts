function plot_vf(tr,,graphPath,rootname,ext)
    if nargin<4, ext='png';end
    if nargin<3, rootname='nosession';end
    if nargin<2, graphPath='';end
    
    fig=figure();
    if isfield(tr.ts,'x')
        %unimanual trial
        subplot(1,3,1);
        plot(tr.ts.xnorm,tr.ts.vnorm,'color',[1,.7,1]);        
        hold on; 
        i=isfinite(tr.vf.vectors{1}) & isfinite(tr.vf.vectors{2});
        [X,Y]=meshgrid(tr.vf.vectors{end}{1},tr.vf.vectors{end}{2});
        quiver(X(i),Y(i),tr.vf.vectors{1}(i),tr.vf.vectors{2}(i));
        hold off;
        axis tight;
        subplot(1,3,2);
        imagesc(flipud(tr.vf.angles{1}),[0,pi]);
        subplot(1,3,3);
        imagesc(flipud(tr.vf.angles{2}),[0,pi]);
    else
        %Left hand vector fields, trajectory and angles
        subplot(3,2,1);
        plot(tr.ts.Lxnorm,tr.ts.Lvnorm,'color',[1,.7,1]);        
        hold on; 
        i=isfinite(tr.vfL.vectors{1}) & isfinite(tr.vfL.vectors{2});
        [X,Y]=meshgrid(tr.vfL.vectors{end}{1},tr.vfL.vectors{end}{2});
        quiver(X(i),Y(i),tr.vfL.vectors{1}(i),tr.vfL.vectors{2}(i));
        hold off;
        axis tight;

        subplot(3,2,3);
        imagesc(flipud(tr.vfL.angles{1}),[-pi,pi]);

        subplot(3,2,5);
        imagesc(flipud(tr.vfL.angles{2}),[0,pi]);

        %Right hand vector fields, trajectory and angles
        subplot(3,2,2);
        plot(tr.ts.Rxnorm,tr.ts.Rvnorm,'color',[1,.7,1]);    
        hold on; 
        i=isfinite(tr.vfR.vectors{1}) & isfinite(tr.vfR.vectors{2});
        [X,Y]=meshgrid(tr.vfR.vectors{end}{1},tr.vfR.vectors{end}{2});
        quiver(X(i),Y(i),tr.vfR.vectors{1}(i),tr.vfR.vectors{2}(i));
        hold off;
        axis tight;    
        subplot(3,2,4);
        imagesc(flipud(tr.vfR.angles{1}),[-pi,pi]);    
        subplot(3,2,6);
        imagesc(flipud(tr.vfR.angles{2}),[0,pi]);
    end
    
    if ~isempty(figname)
        hgsave(fig,figname); close fig;
    end
end
