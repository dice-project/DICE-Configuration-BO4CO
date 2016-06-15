#!/bin/sh
# script for installing the MATLAB runtime environment
#
sudo apt-get update && sudo apt-get upgrade -y &&\
sudo apt-get install g++ libxmu6 libxt6 libxpm4 libxp6 zip -y &&\
mkdir mcr && cd mcr &&\
wget http://uk.mathworks.com/supportfiles/downloads/R2015a/deployment_files/R2015a/installers/glnxa64/MCR_R2015a_glnxa64_installer.zip &&\
unzip MCR_R2015a_glnxa64_installer.zip &&\
sudo ./install -mode silent -agreeToLicense yes