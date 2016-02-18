#!/bin/bash -u

source /root/sat-env

hammer hostgroup create --architecture=x86_64 --domain=${MY_DOMAIN} --locations=${MY_LOCATION} --organizations=${MY_ORG} --name=ANY --puppet-ca-proxy-id=1 --puppet-proxy-id=1 --content-source-id=1 --lifecycle-environment=Library --content-view=cv-puppet-modules
hammer hostgroup create --locations=${MY_LOCATION} --organizations=${MY_ORG} --name=${MY_NAME}

hammer lifecycle-environment create --name=ANY-DEV --prior='Library' --organization=${MY_ORG}
hammer lifecycle-environment create --name=ANY-TEST --prior='ANY-DEV' --organization=${MY_ORG}
hammer lifecycle-environment create --name=ANY-PROD --prior='ANY-TEST' --organization=${MY_ORG}

hammer content-view create --name=cv-software-ws --organization=${MY_ORG}
hammer content-view create --name=cv-puppet-ws --organization=${MY_ORG}
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-software-ws
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-puppet-ws

hammer lifecycle-environment create --name=WS-TROUBLESHOOTING --prior='Library' --organization=${MY_ORG}
hammer lifecycle-environment create --name=WS-PRODUCTION --prior='WS-TROUBLESHOOTING' --organization=${MY_ORG}

hammer hostgroup create --locations=${MY_LOCATION} --organizations=${MY_ORG} --parent=${MY_NAME} --name=WS --content-view=cv-puppet-ws

hammer content-view create --name=cv-software-svr --organization=${MY_ORG}
hammer content-view create --name=cv-puppet-svr --organization=${MY_ORG}
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-software-svr
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-puppet-svr

hammer lifecycle-environment create --name=SVR-TROUBLESHOOTING --prior='Library' --organization=${MY_ORG}
hammer lifecycle-environment create --name=SVR-INTEGRATION --prior='SVR-TROUBLESHOOTING' --organization=${MY_ORG}
hammer lifecycle-environment create --name=SVR-PRODUCTION --prior='SVR-INTEGRATION' --organization=${MY_ORG}

hammer hostgroup create --locations=${MY_LOCATION} --organizations=${MY_ORG} --parent=${MY_NAME} --name=SVR --content-view=cv-puppet-svr
