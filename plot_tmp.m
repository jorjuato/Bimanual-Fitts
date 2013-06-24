function plot_tmp()			
	conf=Config();
    conf.parallelMode=0;
	labsConf = findResource(); 
	if matlabpool('size') == 0
		%matlabpool(labsConf.ClusterSize);
		%matlabpool(obj.conf.workers)
		matlabpool local 2;
	end	
    parfor i=1:10
        if i==1 ||i==5 ||i==2 || i==3 || i==4 || i==6 || i==7
            continue
        end
        disp(['Now plotting participant ' num2str(i)])
        p=Participant(i,conf);
        p.plot_angphsp();
        p.plot_angvar('omega');
        p.plot_angvar('alpha');
        p.plot_angvar('xnorm');
        p.plot_angvar('vnorm');
        p.plot_angvar('jerknorm');
        del p
    end
end
		