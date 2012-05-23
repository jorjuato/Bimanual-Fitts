        conf=Config();
        conf.parallelMode=0;
        p=Participant.load(1,conf);
        p.plot();
        an=Analysis(p,conf);
        an.save(1);
        exit