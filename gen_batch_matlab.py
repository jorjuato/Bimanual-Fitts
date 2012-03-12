#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, sys


TEMPLATE="""\
addpath(genpath(%s));

conf=Config();

conf.parallelMode=0;
conf.data_path=%s;
conf.save_path=%s;
conf.plot_path=%s;

conf.binnumber=%d;
conf.step=%d;
conf.minValsToComputeCondProb=%d;
conf.cutoff=%d;

p=Participant(%d,conf);
p.save();
p.plot();
exit""" 

#Define directories
CWD             = os.getcwd()
MYSCRIPTS_DIR   = CWD+"/scripts"
BATCH_OUT_DIR   = CWD+"/batch"
DATA_IN_DIR     = CWD+"/data"
DATA_OUT_DIR    = CWD+"/results"

if not os.path.exists(BATCH_OUT_DIR):
    os.makedirs(BATCH_OUT_DIR)

if not os.path.exists(DATA_OUT_DIR):
    os.makedirs(DATA_OUT_DIR)


#Define parameter ranges
BINS            = range(31,52,10)
STEPS           = range(1,10,2)
MINVALS         = range(1,14,2)
CUTOFFS         = range(8,13,2)
PARTICIPANTS    = range(1,11,1)

for bin in BINS:
    for step in STEPS:
        for minval in MINVALS:
            for cutoff in CUTOFFS:
                for participant in PARTICIPANTS:
                    #Create directory to store results
                    rootname="bins%d_step%d_minval%d_cutoff%d" %\
                             (bin,   step,  minval,  cutoff)                    
                    rootdir=os.path.join(DATA_OUT_DIR,rootname)                
                    if not os.path.exists(rootdir):
                        os.makedirs(rootdir)                       

                    #Open file to write script
                    filename=rootname+'_P'+str(participant)+'.m'
                    bFilepath=os.path.join(BATCH_OUT_DIR,filename)
                    bFile=open(bFilepath,'w')
                    
                    #Replace variables in Template
                    text=TEMPLATE % (MYSCRIPTS_DIR, DATA_IN_DIR, rootdir, rootdir,
                                     bin, step, minval, cutoff, participant)
                    
                    #Write text to file and close
                    bFile.write(text)
                    bFile.close()
                    
                    
