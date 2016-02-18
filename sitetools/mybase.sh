#!/bin/bash -u

source /root/sat-env

hammer content-view create --name=cv-software-cr --organization=${MY_ORG}
hammer content-view create --name=cv-puppet-cr --organization=${MY_ORG}
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-software-cr
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-puppet-cr

hammer lifecycle-environment create --name=CR-INTEGRATION --prior='Library' --organization=${MY_ORG}
hammer lifecycle-environment create --name=CR-PRODUCTION --prior='CR-INTEGRATION' --organization=${MY_ORG}

hammer content-view create --name=cv-software-ws --organization=${MY_ORG}
hammer content-view create --name=cv-puppet-ws --organization=${MY_ORG}
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-software-ws
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-puppet-ws

hammer hostgroup create --architecture=x86_64 --domain=fnal.gov --locations=${MY_LOCATION} --organizations=${MY_ORG} --parent=${MY_NAME} --name=CR --content-view=cv-puppet-cr

