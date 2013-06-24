function define_plot_globals()
global globals_def; globals_def=1;
global ext;         ext='png';
global dpi;         dpi=300; 
global verbose;     verbose=1;
global fid;         fid=1;
global order;       order=1;

%Proper figure labels
global cnames
global dnames
global lnames
global rnames
global snames
global vnames
global vstrns
cnames={'Strong','Weak'};
lnames={'Easy','Difficult'};
rnames={'Easy','Medium','Difficult'};
snames={'S1','S2','S3'};    
dnames={'Zero','Small','Large'};
vnames={'MTL','MTR','accQL','accQR','HarmonicityL','HarmonicityR','IPerfEfL','IPerfEfR','vfCircularityL','vfCircularityR','maxangleL','maxangleR','rho','flsPC','phDiffStd','minPeakDelay','minPeakDelayNorm'};
vstrns={'MT_L','MT_R','AQ_L','AQ_R','H_L','H_R','IPE_L','IPE_R','VFC_L','VFC_R','MA_L','MA_R','\rho','FLS','\phi_{\sigma}','dpeaks','dpeaks_{norm}'};

'hola'
end
