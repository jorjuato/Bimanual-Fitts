#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os, sys, subprocess
from multiprocessing import Pool

#GLOBALS
MAIN_DIR   = "/home/jorge/Dropbox/dev/Bimanual-Fitts"
PYTHON_DIR = os.path.join(MAIN_DIR,"python")
BATCH_DIR  = os.path.join(PYTHON_DIR,"batch")
if not os.path.exists(BATCH_DIR):
    os.makedirs(BATCH_DIR)


WRKs=5
PPno=10
PPs=range(1,PPno+1)
#PPs=[9]
#PPno=len(PPs)

TEMPLATE_FULL,\
TEMPLATE_FULL2,\
TEMPLATE_LOAD_SAVE,\
TEMPLATE_LOAD_SAVE_PLOT,\
TEMPLATE_GET_DATA,\
TEMPLATE_ANALYSIS,\
TEMPLATE_PLOT_ANALYSIS,\
TEMPLATE_LOAD_PLOT,\
TEMPLATE_PLOT = range(9)

def write_scripts(pp):    
    #Open file to write script
    filename="pp%03d.m" % pp
    filepath=os.path.join(BATCH_DIR,filename)
    f=open(filepath,'w')
    
    #Write text to file and close
    f.write(get_script_from_template(TEMPLATE_GET_DATA,pp))
    f.close()
    return "nohup /opt/matlab/bin/matlab -nodesktop -nosplash -r %s > ~/%s.out" % (filename[:-2],filename[:-2])

def get_script_from_template(tpl,pp):
    if tpl==TEMPLATE_FULL:
        msg="""\
        conf=Config();
        conf.parallelMode=0;
        p=Participant(%d,conf);
        p.save(); p.plot(); 
        an=Analysis(p); an.save(%d);
        exit""" % (pp,pp)    
    elif tpl==TEMPLATE_FULL2:
        msg="""\
        conf=Config();
        conf.parallelMode=0;
        p=Participant(%d,conf);
        p.save(); 
        [dataBi,dataUn,varnamesBi,varnamesUn,vartypesBi, vartypesUn] = get_data_pp(p);
        save(joinpath(conf.save_path,'pp%02d_data.mat'),'dataBi','dataUn','varnamesBi','varnamesUn','vartypesBi','vartypesUn'); exit""" % (pp,pp) 
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
    elif tpl==TEMPLATE_GET_DATA:
        msg="""\
        RandStream.setDefaultStream(RandStream('mt19937ar','seed',sum(100*clock)));
        conf=Config();
        [dataBi,dataUn,varnamesBi,varnamesUn,vartypesBi, vartypesUn] = get_data_pp(%d);
        save(joinpath(conf.save_path,'pp%02d_data.mat')); exit""" % (pp,pp)
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
    
    if sys.version_info[1] <= 6 or sys.version_info[0] == 3: 
        pool=Pool(processes=WRKs)
    else:
        pool=Pool(processes=WRKs,maxtasksperchild=1)
        
    pool.map(os.system, map(write_scripts,PPs), round(PPno/WRKs) )
    pool.close()
    pool.join()
    sys.exit()
