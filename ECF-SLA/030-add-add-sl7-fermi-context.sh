#!/bin/bash -u

source /root/sat-env

# Add the Fermi context, but hopefully we are doing most of the work
#  in puppet....

hammer repository create --gpg-key="Scientific Linux" --name='SL 7 Context Fermilab - x86_64' --organization=${MY_ORG} --product='Scientific Linux 7' --content-type='yum' --publish-via-http=false --url=http://ftp.scientificlinux.org/linux/scientific/7x/contexts/fermilab/x86_64/
hammer content-view add-repository --organization=${MY_ORG} --product='Scientific Linux 7' --repository='SL 7 Context Fermilab - x86_64' --name=cv-software-sl7

