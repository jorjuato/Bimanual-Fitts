        conf=Config();
        conf.parallelMode=0;
        p=Participant.load(4,conf);
        p.plot();
        an=Analysis(p,conf);
        an.save(4);
        exit