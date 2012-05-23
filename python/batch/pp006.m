        conf=Config();
        conf.parallelMode=0;
        p=Participant.load(6,conf);
        p.plot();
        an=Analysis(p,conf);
        an.save(6);
        exit