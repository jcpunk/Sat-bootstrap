#!/bin/bash -u

source /root/sat-env

TYPES="ws svr cr"

for kind in ${TYPES}; do
    kind_UC=$(echo ${kind} | tr '[:lower:]' '[:upper:]')

    hammer repository create --name="${kind_UC} RPMs - EL7 - x86_64" --organization=${MY_ORG} --product='Lifecycle Environment Related' --content-type='yum' --publish-via-http=false
    hammer repository create --name="${kind_UC} RPMs - EL6 - x86_64" --organization=${MY_ORG} --product='Lifecycle Environment Related' --content-type='yum' --publish-via-http=false
    hammer repository create --name="${kind_UC} Puppet Modules" --organization=${MY_ORG} --product='Lifecycle Environment Related' --content-type='puppet' --publish-via-http=false

    hammer content-view create --name=cv-software-${kind}-el6 --organization=${MY_ORG}
    hammer content-view create --name=cv-software-${kind}-el7 --organization=${MY_ORG}
    hammer content-view create --name=cv-puppet-${kind} --organization=${MY_ORG}

    hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-software-${kind}-el6
    hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-software-${kind}-el7
    hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-puppet-${kind}

    hammer content-view add-repository --organization=${MY_ORG} --product='Lifecycle Environment Related' --repository="${kind_UC} RPMs - EL6 - x86_64" --name=cv-software-${kind}-el6
    hammer content-view add-repository --organization=${MY_ORG} --product='Lifecycle Environment Related' --repository="${kind_UC} RPMs - EL7 - x86_64" --name=cv-software-${kind}-el7
    hammer content-view add-repository --organization=${MY_ORG} --product='Lifecycle Environment Related' --repository="${kind_UC} Puppet Modules" --name=cv-puppet-${kind}
done
