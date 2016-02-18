#!/bin/bash -u

source /root/sat-env

hammer product create --gpg-key="Scientific Linux" --name='Scientific Linux Fermi 6' --label='slf6' --organization=Fermilab

hammer repository create --gpg-key="Scientific Linux" --name='SLF 6x - x86_64' --organization=Fermilab --product='Scientific Linux Fermi 6' --content-type='yum' --publish-via-http=true --url=http://ftp.scientificlinux.org/linux/fermi/slf6x/x86_64/os/
hammer repository create --gpg-key="Scientific Linux" --name='SLF 6x security - x86_64' --organization=Fermilab --product='Scientific Linux Fermi 6' --content-type='yum' --publish-via-http=true --url=http://ftp.scientificlinux.org/linux/fermi/slf6x/x86_64/updates/security
hammer repository create --gpg-key="Scientific Linux" --name='SLF 6x fastbugs - x86_64' --organization=Fermilab --product='Scientific Linux Fermi 6' --content-type='yum' --publish-via-http=true --url=http://ftp.scientificlinux.org/linux/fermi/slf6x/x86_64/updates/fastbugs
hammer content-view add-repository --organization=Fermilab --product='Scientific Linux Fermi 6' --repository='SLF 6x - x86_64' --name=cv-software-slf6
hammer content-view add-repository --organization=Fermilab --product='Scientific Linux Fermi 6' --repository='SLF 6x security - x86_64' --name=cv-software-slf6
hammer content-view add-repository --organization=Fermilab --product='Scientific Linux Fermi 6' --repository='SLF 6x fastbugs - x86_64' --name=cv-software-slf6

hammer product set-sync-plan --sync-plan='6pm Fri' --organization=Fermilab --name='Scientific Linux Fermi 6'

