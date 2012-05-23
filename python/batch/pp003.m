        conf=Config();
        conf.parallelMode=0;
        p=Participant.load(3,conf);
        p.plot();
        an=Analysis(p,conf);
        an.save(3);
        exit