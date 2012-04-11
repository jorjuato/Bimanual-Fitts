#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, sys, subprocess
from multiprocessing import Pool

#GLOBALS
SCRIPTS_DIR="/home/jorge/Dropbox/dev/Bimanual-Fitts"
BATCH_OUT_DIR=os.path.join(SCRIPTS_DIR,"batchls")
ROOT_DIR="/media/data/cTS_ncVF"
if not os.path.exists(BATCH_OUT_DIR):
    os.makedirs(BATCH_OUT_DIR)
WRKs=3
PPs=10
TEMPLATE="""\
conf=Config('%s');
conf.parallelMode=0;
conf.compress_pc=0;
p=Participant.load(%d,conf);
p.update_ls();
p.conf.save_path='/media/data/cTS_ncVF';
p.save();
exit"""

def write_scripts(pp):    
    #Open file to write script
    filename="ppls%03d.m" % pp
    filepath=os.path.join(BATCH_OUT_DIR,filename)
    f=open(filepath,'w')
    
    #Write text to file and close
    f.write(TEMPLATE % (ROOT_DIR, pp) )
    f.close()
    return "nohup /opt/matlab/bin/matlab -nodesktop -nosplash -r %s > /dev/null" % filename[:-2]

if __name__ == '__main__':
    pool=Pool(processes=WRKs)
    pool.map(os.system, map(write_scripts,range(1,PPs+1)), round(PPs/WRKs) )
