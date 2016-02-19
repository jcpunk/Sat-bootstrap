#!/bin/bash -u

source /root/sat-env

hammer lifecycle-environment create --name=ANY-DEV --prior='Library' --organization=${MY_ORG}
hammer lifecycle-environment create --name=ANY-TEST --prior='ANY-DEV' --organization=${MY_ORG}
hammer lifecycle-environment create --name=ANY-PROD --prior='ANY-TEST' --organization=${MY_ORG}

hammer lifecycle-environment create --name=WS-TROUBLESHOOTING --prior='Library' --organization=${MY_ORG}
hammer lifecycle-environment create --name=WS-PRODUCTION --prior='WS-TROUBLESHOOTING' --organization=${MY_ORG}

hammer lifecycle-environment create --name=SVR-TROUBLESHOOTING --prior='Library' --organization=${MY_ORG}
hammer lifecycle-environment create --name=SVR-INTEGRATION --prior='SVR-TROUBLESHOOTING' --organization=${MY_ORG}
hammer lifecycle-environment create --name=SVR-PRODUCTION --prior='SVR-INTEGRATION' --organization=${MY_ORG}

hammer lifecycle-environment create --name=CR-INTEGRATION --prior='Library' --organization=${MY_ORG}
hammer lifecycle-environment create --name=CR-PRODUCTION --prior='CR-INTEGRATION' --organization=${MY_ORG}
