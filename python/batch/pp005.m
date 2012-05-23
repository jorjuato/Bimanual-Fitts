        conf=Config();
        conf.parallelMode=0;
        p=Participant.load(5,conf);
        p.plot();
        an=Analysis(p,conf);
        an.save(5);
        exit