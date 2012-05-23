        conf=Config();
        conf.parallelMode=0;
        p=Participant.load(8,conf);
        p.plot();
        an=Analysis(p,conf);
        an.save(8);
        exit