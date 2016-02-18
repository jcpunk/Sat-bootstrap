#!/bin/bash -u

source /root/sat-env

hammer repository-set enable --organization=Fermilab --product='Red Hat Satellite'  --basearch='x86_64' --name='Red Hat Satellite 6.1 (for RHEL 7 Server) (RPMs)'

hammer repository-set enable --organization=Fermilab --product='Red Hat Software Collections for RHEL Server' --basearch='x86_64' --releasever='6Server' --name='Red Hat Software Collections RPMs for Red Hat Enterprise Linux 6 Server'
hammer repository-set enable --organization=Fermilab --product='Red Hat Software Collections for RHEL Server' --basearch='x86_64' --releasever='7Server' --name='Red Hat Software Collections RPMs for Red Hat Enterprise Linux 7 Server'

hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --name='Red Hat Enterprise Linux 7 Server - Fastrack (RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --releasever=7Server --name='Red Hat Enterprise Linux 7 Server - Optional (RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --releasever=7Server --name='Red Hat Enterprise Linux 7 Server (Kickstart)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --name='Red Hat Enterprise Linux 7 Server - Extras (RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --name='Red Hat Satellite Tools 6.1 (for RHEL 7 Server) (RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --name='Red Hat Satellite Tools 6.1 (for RHEL 7 Server) (Source RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --releasever=7Server --name='Red Hat Enterprise Linux 7 Server - RH Common (RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --name='Red Hat Enterprise Linux 7 Server - Optional Fastrack (RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --releasever=7Server --name='Red Hat Enterprise Linux 7 Server (RPMs)'

hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --name='Red Hat Enterprise Linux 6 Server - Fastrack (RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --releasever=6Server --name='Red Hat Enterprise Linux 6 Server - Optional (RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --releasever=6Server --name='Red Hat Enterprise Linux 6 Server (Kickstart)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --name='Red Hat Satellite Tools 6.1 (for RHEL 6 Server) (RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --name='Red Hat Satellite Tools 6.1 (for RHEL 6 Server) (Source RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --releasever=6Server --name='Red Hat Enterprise Linux 6 Server - RH Common (RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --name='Red Hat Enterprise Linux 6 Server - Optional Fastrack (RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --releasever=6Server --name='Red Hat Enterprise Linux 6 Server (RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --releasever=6Server --name='Red Hat Enterprise Virtualization Agents for RHEL 6 Server (RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --releasever=6Server --name='Red Hat Enterprise Virtualization Agents for RHEL 6 Server (Source RPMs)'

hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --name='Red Hat Enterprise Linux 5 Server - Fastrack (RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --releasever=5Server --name='Red Hat Enterprise Linux 5 Server (Kickstart)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --name='Red Hat Satellite Tools 6.1 (for RHEL 5 Server) (RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --name='Red Hat Satellite Tools 6.1 (for RHEL 5 Server) (Source RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --releasever=5Server --name='Red Hat Enterprise Linux 5 Server - RH Common (RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --releasever=5Server --name='Red Hat Enterprise Linux 5 Server (RPMs)'
hammer repository-set enable --organization=Fermilab --product='Red Hat Enterprise Linux Server' --basearch=x86_64 --releasever=5Server --name='Red Hat Enterprise Virtualization Agents for RHEL 5 Server (RPMs)'


hammer product set-sync-plan --sync-plan='6pm Fri' --organization=Fermilab --name='Red Hat Satellite'
hammer product set-sync-plan --sync-plan='6pm Fri' --organization=Fermilab --name='Red Hat Software Collections for RHEL Server'
hammer product set-sync-plan --sync-plan='6pm Fri' --organization=Fermilab --name='Red Hat Enterprise Linux Server'

