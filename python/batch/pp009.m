        conf=Config();
        conf.parallelMode=0;
        p=Participant.load(9,conf);
        p.plot();
        an=Analysis(p,conf);
        an.save(9);
        exit