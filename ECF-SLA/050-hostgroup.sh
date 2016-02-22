#!/bin/bash -u

source /root/sat-env

MY_NAME_LC=$(echo ${MY_NAME} | tr '[:upper:]' '[:lower:]' | tr '-' '_')

# Create a dummy top level host group
# Then create a host group for our group
# Then a host group for our lifecycles

hammer hostgroup create --architecture=x86_64 --domain=${MY_DOMAIN} --locations=${MY_LOCATION} --organizations=${MY_ORG} --name=ANY --puppet-ca-proxy-id=1 --puppet-proxy-id=1 --content-source-id=1 --lifecycle-environment=Library --content-view=cv-puppet-forge

hammer hostgroup create --locations=${MY_LOCATION} --organizations=${MY_ORG} --name=${MY_NAME} --lifecycle-environment=Library --puppet-ca-proxy-id=1 --puppet-proxy-id=1 --content-source-id=1 --content-view=cv-puppet-${MY_NAME_LC} --parent=ANY

hammer hostgroup create --locations=${MY_LOCATION} --organizations=${MY_ORG} --parent=${MY_NAME} --name=WS --content-view=cv-puppet-ws

hammer hostgroup create --locations=${MY_LOCATION} --organizations=${MY_ORG} --parent=${MY_NAME} --name=SVR --content-view=cv-puppet-svr

hammer hostgroup create --locations=${MY_LOCATION} --organizations=${MY_ORG} --parent=${MY_NAME} --name=CR --content-view=cv-puppet-cr
