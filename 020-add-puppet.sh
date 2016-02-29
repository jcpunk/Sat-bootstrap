#!/bin/bash -u

source /root/sat-env

# Setup a Puppet product with the Forge for modules
#  if we are using our own puppet either for non-RHEL (but EL) systems or puppet enterprise
#   we will need our own clients, setup a place to hand them out

hammer product create --name='Puppet' --organization=${MY_ORG}

hammer content-view create --name=cv-software-puppet-el6 --organization=${MY_ORG}
hammer content-view create --name=cv-software-puppet-el7 --organization=${MY_ORG}
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-software-puppet-el6
hammer content-view publish --async --organization=${MY_ORG} --description=Empty --name=cv-software-puppet-el7
hammer repository create --name='Puppetlabs Forge' --organization=${MY_ORG} --product='Puppet' --content-type='puppet' --publish-via-http=false --url=https://forge.puppetlabs.com

hammer repository create --name='Puppet Clients - EL7 - x86_64' --organization=${MY_ORG} --product='Puppet' --content-type='yum' --publish-via-http=false
hammer repository create --name='Puppet Clients - EL6 - x86_64' --organization=${MY_ORG} --product='Puppet' --content-type='yum' --publish-via-http=false 

hammer product set-sync-plan --sync-plan='6pm' --organization=${MY_ORG} --name='Puppet'

