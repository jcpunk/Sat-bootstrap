#!/bin/bash -u

source /root/sat-env

# We will need someplace to store our group specific packages

MY_NAME_LC=$(echo ${MY_NAME} | tr '[:upper:]' '[:lower:]' | tr '-' '_')

hammer content-view create --name=cv-software-${MY_NAME_LC}-el6 --organization=${MY_ORG}
hammer content-view create --name=cv-software-${MY_NAME_LC}-el7 --organization=${MY_ORG}

hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-software-${MY_NAME_LC}-el6
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-software-${MY_NAME_LC}-el7

hammer repository create --name="RPMs for ${MY_NAME} on el7 - x86_64" --organization=${MY_ORG} --product="${MY_NAME}" --content-type='yum' --publish-via-http=false
hammer repository create --name="RPMs for ${MY_NAME} on el6 - x86_64" --organization=${MY_ORG} --product="${MY_NAME}" --content-type='yum' --publish-via-http=false

hammer content-view add-repository --organization=${MY_ORG} --product="${MY_NAME}" --repository="RPMs for ${MY_NAME} on el7 - x86_64" --name=cv-software-${MY_NAME_LC}-el7
hammer content-view add-repository --organization=${MY_ORG} --product="${MY_NAME}" --repository="RPMs for ${MY_NAME} on el6 - x86_64" --name=cv-software-${MY_NAME_LC}-el6

