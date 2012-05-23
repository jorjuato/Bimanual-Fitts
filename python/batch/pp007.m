        conf=Config();
        conf.parallelMode=0;
        p=Participant.load(7,conf);
        p.plot();
        an=Analysis(p,conf);
        an.save(7);
        exit