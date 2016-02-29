#!/bin/bash -u

source /root/sat-env

# Setup Scientific Linux 7

hammer content-view create --name=cv-software-sl7 --organization=${MY_ORG}
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-software-sl7

curl http://ftp.scientificlinux.org/linux/scientific/6x/x86_64/os/RPM-GPG-KEY-sl http://ftp.scientificlinux.org/linux/scientific/6x/x86_64/os/RPM-GPG-KEY-sl6 http://ftp.scientificlinux.org/linux/scientific/7x/x86_64/os/RPM-GPG-KEY-sl7 > /tmp/sl.pubkey
hammer gpg create --name="Scientific Linux" --key=/tmp/sl.pubkey  --organization=${MY_ORG}

hammer product create --gpg-key="Scientific Linux" --name='Scientific Linux 7' --label='sl7' --organization=${MY_ORG}

hammer repository create --gpg-key="Scientific Linux" --name='SL 7x - x86_64' --organization=${MY_ORG} --product='Scientific Linux 7' --content-type='yum' --publish-via-http=false --url=http://ftp.scientificlinux.org/linux/scientific/7x/x86_64/os/
hammer repository create --gpg-key="Scientific Linux" --name='SL 7x security - x86_64' --organization=${MY_ORG} --product='Scientific Linux 7' --content-type='yum' --publish-via-http=false --url=http://ftp.scientificlinux.org/linux/scientific/7x/x86_64/updates/security
hammer repository create --gpg-key="Scientific Linux" --name='SL 7x fastbugs - x86_64' --organization=${MY_ORG} --product='Scientific Linux 7' --content-type='yum' --publish-via-http=false --url=http://ftp.scientificlinux.org/linux/scientific/7x/x86_64/updates/fastbugs

hammer content-view add-repository --organization=${MY_ORG} --product='Scientific Linux 7' --repository='SL 7x - x86_64' --name=cv-software-sl7
hammer content-view add-repository --organization=${MY_ORG} --product='Scientific Linux 7' --repository='SL 7x security - x86_64' --name=cv-software-sl7
hammer content-view add-repository --organization=${MY_ORG} --product='Scientific Linux 7' --repository='SL 7x fastbugs - x86_64' --name=cv-software-sl7

hammer product set-sync-plan --sync-plan='6pm Fri' --organization=${MY_ORG} --name='Scientific Linux 7'

