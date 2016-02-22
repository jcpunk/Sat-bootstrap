#!/bin/bash -u

source /root/sat-env

hammer organization create --name=${MY_ORG}
hammer location create --name=${MY_LOCATION}
hammer domain create --name=${MY_DOMAIN}

hammer organization add-domain --domain=${MY_DOMAIN} --name=${MY_ORG}
hammer location add-domain --domain=${MY_DOMAIN} --name=${MY_LOCATION}

# In theory we've gone home for the day by 6pm, so fire off syncs then
hammer sync-plan create --interval=weekly --name='6pm Fri' --sync-date='2015-01-03 00:00:00' --organization=${MY_ORG} --enabled=true
hammer sync-plan create --interval=daily --name='6pm' --sync-date='2015-01-03 00:00:00' --organization=${MY_ORG} --enabled=true

# We will need some place to store hostgroup related items, more on that later
hammer product create --name='Host Group Related' --organization=${MY_ORG}

