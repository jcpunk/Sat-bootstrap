#!/bin/bash -u

source /root/sat-env

# EPEL, it needs little introduction

curl https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-5 https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6 https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 > /tmp/epel.pubkey
hammer gpg create --name="EPEL" --key=/tmp/epel.pubkey  --organization=${MY_ORG}

hammer product create --gpg-key="EPEL" --name='EPEL' --organization=${MY_ORG}

hammer content-view create --name=cv-software-epel-el6 --organization=${MY_ORG}
hammer content-view create --name=cv-software-epel-el7 --organization=${MY_ORG}
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-software-epel-el6
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-software-epel-el7
hammer repository create --gpg-key="EPEL" --name='EPEL 7 - x86_64' --organization=${MY_ORG} --product='EPEL' --content-type='yum' --publish-via-http=true --url=http://dl.fedoraproject.org/pub/epel/7/x86_64/
hammer repository create --gpg-key="EPEL" --name='EPEL 6 - x86_64' --organization=${MY_ORG} --product='EPEL' --content-type='yum' --publish-via-http=true --url=http://dl.fedoraproject.org/pub/epel/6/x86_64/
hammer content-view add-repository --organization=${MY_ORG} --product=EPEL --repository='EPEL 7 - x86_64' --name=cv-software-epel-el7
hammer content-view add-repository --organization=${MY_ORG} --product=EPEL --repository='EPEL 6 - x86_64' --name=cv-software-epel-el6

hammer product set-sync-plan --sync-plan='6pm Fri' --organization=${MY_ORG} --name='EPEL'

