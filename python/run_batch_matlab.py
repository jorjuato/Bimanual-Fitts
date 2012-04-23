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
PPs=10
TEMPLATE="""\
conf=Config();
conf.parallelMode=0;
p=Participant(%d,conf);
p.save();
exit"""

def write_scripts(pp):    
    #Open file to write script
    filename="pp%03d.m" % pp
    filepath=os.path.join(BATCH_OUT_DIR,filename)
    f=open(filepath,'w')
    
    #Write text to file and close
    f.write(TEMPLATE % pp)
    f.close()
    return "nohup /opt/matlab/bin/matlab -nodesktop -nosplash -r %s > /dev/null" % filename[:-2]

if __name__ == '__main__':
    pool=Pool(processes=WRKs)
    pool.map(os.system, map(write_scripts,range(1,PPs+1)), round(PPs/WRKs) )
