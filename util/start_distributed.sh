#!/bin/bash
#To be run in the machine acting as a client
#It will launch the distributed servers on each computing node,
#the remote jobmanager, add workers

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user" 2>&1
  exit 1
fi

cd /opt/matlab/toolbox/distcomp/bin
./mdce start
./remotemdce start -matlabroot /opt/matlab -remotehost vibrator -remoteplatform UNIX -protocol ssh -username root
./startjobmanager -name ergonomia -remotehost vibrator -clean
echo "Starting local workers"
./startworker -name worker1 -jobmanager ergonomia -jobmanagerhost vibrator 
./startworker -name worker2 -jobmanager ergonomia -jobmanagerhost vibrator 
./startworker -name worker3 -jobmanager ergonomia -jobmanagerhost vibrator 
./startworker -name worker4 -jobmanager ergonomia -jobmanagerhost vibrator 
echo "Starting workers in vibrator."
./startworker -name worker11 -jobmanager ergonomia -jobmanagerhost vibrator -remotehost vibrator
./startworker -name worker12 -jobmanager ergonomia -jobmanagerhost vibrator -remotehost vibrator
./startworker -name worker13 -jobmanager ergonomia -jobmanagerhost vibrator -remotehost vibrator
./startworker -name worker14 -jobmanager ergonomia -jobmanagerhost vibrator -remotehost vibrator
./startworker -name worker15 -jobmanager ergonomia -jobmanagerhost vibrator -remotehost vibrator
./startworker -name worker16 -jobmanager ergonomia -jobmanagerhost vibrator -remotehost vibrator
./startworker -name worker17 -jobmanager ergonomia -jobmanagerhost vibrator -remotehost vibrator
./startworker -name worker18 -jobmanager ergonomia -jobmanagerhost vibrator -remotehost vibrator
./mdce status
./remotemdce status -matlabroot /opt/matlab -remotehost vibrator -remoteplatform UNIX -protocol ssh -username root
exit 0
