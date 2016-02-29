#!/bin/bash -u

source /root/sat-env

# ELRepo is a great source for useful kmods and newer kernels, set it up

curl https://www.elrepo.org/RPM-GPG-KEY-elrepo.org > /tmp/elrepo.pubkey
hammer gpg create --name="ELRepo" --key=/tmp/elrepo.pubkey  --organization=${MY_ORG}

hammer product create --gpg-key="ELRepo" --name='ELRepo' --organization=${MY_ORG}

hammer content-view create --name=cv-software-elrepo-kmods-el6 --organization=${MY_ORG}
hammer content-view create --name=cv-software-elrepo-kmods-el7 --organization=${MY_ORG}
hammer content-view create --name=cv-software-elrepo-kernels-el6 --organization=${MY_ORG}
hammer content-view create --name=cv-software-elrepo-kernels-el7 --organization=${MY_ORG}
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-software-elrepo-kmods-el6
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-software-elrepo-kmods-el7
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-software-elrepo-kernels-el6
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-software-elrepo-kernels-el7
hammer repository create --gpg-key="ELRepo" --name='ELRepo kmods for EL7 - x86_64' --organization=${MY_ORG} --product='ELRepo' --content-type='yum' --publish-via-http=false --url=http://ftp.osuosl.org/pub/elrepo/elrepo/el7/x86_64/
hammer repository create --gpg-key="ELRepo" --name='ELRepo kernels for EL7 - x86_64' --organization=${MY_ORG} --product='ELRepo' --content-type='yum' --publish-via-http=false --url=http://ftp.osuosl.org/pub/elrepo/kernel/el7/x86_64/
hammer repository create --gpg-key="ELRepo" --name='ELRepo kmods for EL6 - x86_64' --organization=${MY_ORG} --product='ELRepo' --content-type='yum' --publish-via-http=false --url=http://ftp.osuosl.org/pub/elrepo/elrepo/el6/x86_64/
hammer repository create --gpg-key="ELRepo" --name='ELRepo kernels for EL6 - x86_64' --organization=${MY_ORG} --product='ELRepo' --content-type='yum' --publish-via-http=false --url=http://ftp.osuosl.org/pub/elrepo/kernel/el6/x86_64/
hammer content-view add-repository --organization=${MY_ORG} --product=ELRepo --repository='ELRepo kmods for EL7 - x86_64' --name=cv-software-elrepo-kmods-el7
hammer content-view add-repository --organization=${MY_ORG} --product=ELRepo --repository='ELRepo kmods for EL6 - x86_64' --name=cv-software-elrepo-kmods-el6
hammer content-view add-repository --organization=${MY_ORG} --product=ELRepo --repository='ELRepo kernels for EL6 - x86_64' --name=cv-software-elrepo-kernels-el6
hammer content-view add-repository --organization=${MY_ORG} --product=ELRepo --repository='ELRepo kernels for EL7 - x86_64' --name=cv-software-elrepo-kernels-el7

hammer product set-sync-plan --sync-plan='6pm Fri' --organization=${MY_ORG} --name='ELRepo'

