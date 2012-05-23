        conf=Config();
        conf.parallelMode=0;
        p=Participant.load(2,conf);
        p.plot();
        an=Analysis(p,conf);
        an.save(2);
        exit