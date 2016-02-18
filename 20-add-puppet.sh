#!/bin/bash -u

source /root/sat-env

hammer product create --name='Puppet' --organization=${MY_ORG}

hammer content-view create --name=cv-puppet-modules --organization=Fermilab
hammer content-view create --name=cv-software-puppet-el6 --organization=Fermilab
hammer content-view create --name=cv-software-puppet-el7 --organization=Fermilab
hammer content-view publish --async --organization=Fermilab --description=Empty --name=cv-puppet-modules
hammer content-view publish --async --organization=Fermilab --description=Empty --name=cv-software-puppet-el6
hammer content-view publish --async --organization=Fermilab --description=Empty --name=cv-software-puppet-el7
hammer repository create --name='Puppetlabs Forge' --organization=Fermilab --product='Puppet' --content-type='puppet' --publish-via-http=true --url=https://forge.puppetlabs.com

hammer repository create --name='Puppet Clients - EL7 - x86_64' --organization=Fermilab --product='Puppet' --content-type='yum' --publish-via-http=false
hammer repository create --name='Puppet Clients - EL6 - x86_64' --organization=Fermilab --product='Puppet' --content-type='yum' --publish-via-http=false 

hammer product set-sync-plan --sync-plan='6pm' --organization=Fermilab --name='Puppet'

