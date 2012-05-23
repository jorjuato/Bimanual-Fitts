        conf=Config();
        conf.parallelMode=0;
        p=Participant.load(10,conf);
        p.plot();
        an=Analysis(p,conf);
        an.save(10);
        exit