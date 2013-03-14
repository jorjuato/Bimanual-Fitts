function plot(obj,graphPath,rootname,ext)
    if nargin<4, ext='png';end
    if nargin<3, rootname=[];end
    if nargin<2, graphPath=[];end
    
%     %Create figure for this function
%     if ischar(graphPath) 
%         fig = figure('visible','off');
%     elseif ~iscell(graphPath)
%         fig = figure();
%     end
    

    %disp('Nothing to plot at this level...');
    disp(obj);
end