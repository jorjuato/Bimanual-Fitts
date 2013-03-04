        RandStream.setDefaultStream(RandStream('mt19937ar','seed',sum(100*clock)));
        conf=Config();
        [dataBi,dataUn,varnamesBi,varnamesUn,vartypesBi, vartypesUn] = get_data_pp(6);
        save(joinpath(conf.save_path,'pp06_data.mat')); exit