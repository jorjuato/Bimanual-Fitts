#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, sys, subprocess
from multiprocessing import Pool

#GLOBALS
BATCH_OUT_DIR   = os.getcwd()+"/batch"
SCRIPTS_DIR="/home/jorge/Dropbox/dev/Bimanual-Fitts"
if not os.path.exists(BATCH_OUT_DIR):
    os.makedirs(BATCH_OUT_DIR)


WRKs=5
PPno=10
PPs=range(1,PPno+1)
#PPs=[4,6,8,9,10]

TEMPLATE_FULL,\
TEMPLATE_LOAD_SAVE,\
TEMPLATE_LOAD_SAVE_PLOT,\
TEMPLATE_ANALYSIS,\
TEMPLATE_PLOT_ANALYSIS,\
TEMPLATE_LOAD_PLOT,\
TEMPLATE_PLOT = range(7)

def write_scripts(pp):    
    #Open file to write script
    filename="pp%03d.m" % pp
    filepath=os.path.join(BATCH_OUT_DIR,filename)
    f=open(filepath,'w')
    
    #Write text to file and close
    f.write(get_script(TEMPLATE_PLOT_ANALYSIS,pp))
    f.close()
    return "nohup /opt/matlab/bin/matlab -nodesktop -nosplash -r %s" % filename[:-2]

def get_script(tpl,pp):
    if tpl==TEMPLATE_FULL:
        msg="""\
        conf=Config();
        conf.parallelMode=0;
        p=Participant(%d,conf);
        p.save(); p.plot(); 
        an=Analysis(p); an.save(%d);
        exit""" % (pp,pp)    
    elif tpl==TEMPLATE_LOAD_SAVE:
        msg="""\
        conf=Config();
        conf.parallelMode=0;
        p=Participant(%d,conf);
        p.save(); exit""" % pp        
    elif tpl==TEMPLATE_LOAD_SAVE_PLOT:
        msg="""\
        conf=Config();
        conf.parallelMode=0;
        p=Participant(%d,conf);
        p.save(); p.plot(); exit""" % pp        
    elif tpl==TEMPLATE_ANALYSIS:
        msg="""\
        an=Analysis(%d);
        an.save(%d);
        exit""" % (pp,pp)
    elif tpl==TEMPLATE_PLOT_ANALYSIS:
        msg="""\
        conf=Config();
        conf.parallelMode=0;
        p=Participant.load(%d,conf);
        p.plot();
        an=Analysis(p,conf);
        an.save(%d);
        exit""" % (pp,pp)
    elif tpl==TEMPLATE_LOAD_PLOT:
        msg="""\
        conf=Config();
        conf.parallelMode=0;
        p=Participant(%d,conf);
        p.plot();exit""" % pp
    elif tpl==TEMPLATE_PLOT:
        msg="""\
        conf=Config();
        conf.parallelMode=0;
        p=Participant.load(%d,conf);
        p.plot();exit""" % pp
    else:
        return "Wrong template type"
    return msg
    
if __name__ == '__main__':
    if sys.version_info[2] <= 6:
        pool=Pool(processes=WRKs)
    else:
        pool=Pool(processes=WRKs,maxtasksperchild=1)
    pool.map(os.system, map(write_scripts,PPs), round(PPno/WRKs) )
    pool.close()
    pool.join()
    sys.exit()
