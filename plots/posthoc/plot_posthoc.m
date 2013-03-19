function plot_posthoc(mfile,rel,vnames)
if nargin<2, rel=0; end
if nargin<3, vnames={'MTR','MTL','accQR','accQL'};end

obj=load(mfile);
[dataB,dataU,varnamesB,varnamesU,vartypesB,vartypesU]=struct2vars(obj);
dataRel=get_data_rel(dataB,dataU,varnamesB,varnamesU, vartypesB);
if isempty(vnames)
    vnames=varnamesB;
end

for v=1:length(vnames)
    vname=vnames{v};
    % Get absolute flist
    plot_posthoc_var(vname, dataB, vnames,flist)
    if rel
        % Get relative flist
        plot_posthoc_var(vname, dataRel, vnames,flist,rel);
    end
end
end
