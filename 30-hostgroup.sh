#!/bin/bash -u

source /root/sat-env

hammer hostgroup create --architecture=x86_64 --domain=${MY_DOMAIN} --locations=${MY_LOCATION} --organizations=${MY_ORG} --name=ANY --puppet-ca-proxy-id=1 --puppet-proxy-id=1 --content-source-id=1 --lifecycle-environment=Library

