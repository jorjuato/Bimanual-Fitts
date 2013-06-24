function plot_all_4way(vname,obj)
    define_plot_globals();
    
    global order
    
    order=1;
    plot_posthoc_var([vname,'L'],obj.dataB,obj.vnamesB,{{'grp','ss','idl','idr'}},0);
    plot_posthoc_var([vname,'R'],obj.dataB,obj.vnamesB,{{'grp','ss','idl','idr'}},0);
    order=0;
    plot_posthoc_var([vname,'L'],obj.dataB,obj.vnamesB,{{'grp','ss','idl','idr'}},0);
    plot_posthoc_var([vname,'R'],obj.dataB,obj.vnamesB,{{'grp','ss','idl','idr'}},0);
    order=1;
    plot_posthoc_var([vname,'L'],obj.dataRel,obj.vnamesB,{{'grp','ss','idl','idr'}},1);
    plot_posthoc_var([vname,'R'],obj.dataRel,obj.vnamesB,{{'grp','ss','idl','idr'}},1);
    order=0;
    plot_posthoc_var([vname,'L'],obj.dataRel,obj.vnamesB,{{'grp','ss','idl','idr'}},1);
    plot_posthoc_var([vname,'R'],obj.dataRel,obj.vnamesB,{{'grp','ss','idl','idr'}},1);
    
end
