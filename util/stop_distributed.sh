#!/bin/bash
#To be run in the machine acting as a client
#It will kill and clean mdce, jobmanager and workers.


# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user" 2>&1
  exit 1
fi

cd /opt/matlab/toolbox/distcomp/bin
./remotemdce stop -clean -matlabroot /opt/matlab -remotehost vibrator -remoteplatform UNIX -protocol ssh -username  root
./mdce stop -clean
