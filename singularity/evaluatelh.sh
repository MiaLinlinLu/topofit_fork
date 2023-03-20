#!/bin/bash -p
. /opt/miniconda3/bin/activate topofit
#enter the command you would like to run below or modify this script to be more dynamic
#eg. /topofit/evaluate ...
#eg. /topofit/train ... 
#eg. /topofit/preprocess ...
#the following example requires --bind yourtopofitclone:/topofit/
/topofit/evaluate --subjs /data/users2/washbee/speedrun/topofit-data/201818 --hemi lh --model /data/users2/washbee/speedrun/topofit/output/lh.2125.pt