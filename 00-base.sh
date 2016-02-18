#!/bin/bash

MY_NETWORKS="2620:006A:0000::/48 2001:0400:2410::/48 131.225.0.0/16"
DEFAULT_ADMIN_PASSWORD='changeme'
MY_ORG='Fermilab'
MY_LOCATION='Batavia'
MY_DOMAIN='fnal.gov'

############################################################################
echo "MY_ORG=${MY_ORG}" >  /root/sat-env
echo "MY_LOCATION=${MY_LOCATION}" >> /root/sat-env
echo "MY_DOMAIN=${MY_DOMAIN}" >> /root/sat-env
############################################################################
subscription-manager register

subscription-manager refresh
subscription-manager attach
subscription-manager repos --enable=rhel-7-server-extras-rpms
subscription-manager repos --enable=rhel-7-server-fastrack-rpms
subscription-manager repos --enable=rhel-7-server-optional-fastrack-rpms
subscription-manager repos --enable=rhel-7-server-optional-rpms
subscription-manager repos --enable=rhel-7-server-rh-common-rpms
subscription-manager repos --enable=rhel-7-server-rhn-tools-rpms
subscription-manager repos --enable=rhel-7-server-rpms
subscription-manager repos --enable=rhel-7-server-satellite-6.1-rpms
subscription-manager repos --enable=rhel-7-server-satellite-capsule-6.1-rpms
subscription-manager repos --enable=rhel-7-server-satellite-tools-6.1-rpms
subscription-manager repos --enable=rhel-7-server-supplementary-rpms
subscription-manager repos --enable=rhel-ha-for-rhel-7-server-fastrack-rpms
subscription-manager repos --enable=rhel-ha-for-rhel-7-server-rpms
subscription-manager repos --enable=rhel-server-rhscl-7-rpms

yum -y install vim-enhanced tuned sos bash-completion
yum -y update

for service in $(firewall-cmd --list-all --zone=work |grep services | cut -d ':' -f2); do
    firewall-cmd --permanent --zone=work --remove-service=${service}
done

firewall-cmd --permanent --zone=work --add-service=ssh
for net in ${MY_NETWORKS}; do
    firewall-cmd --permanent --zone=work --add-source=${net}
done
firewall-cmd --permanent --zone=work --add-source=10.0.0.0/8
firewall-cmd --permanent --zone=work --add-source=172.16.0.0/12
firewall-cmd --permanent --zone=work --add-source=192.168.0.0/16
firewall-cmd --permanent --zone=trusted --add-source=127.0.0.1

firewall-cmd --permanent --zone=work --add-service=dns
firewall-cmd --permanent --zone=work --add-port="67/udp"
firewall-cmd --permanent --zone=work --add-port="68/udp"
firewall-cmd --permanent --zone=work --add-port="69/udp"
firewall-cmd --permanent --zone=work --add-service=http
firewall-cmd --permanent --zone=work --add-service=https
firewall-cmd --permanent --zone=work --add-port="5647/tcp"
firewall-cmd --permanent --zone=work --add-port="8140/tcp"
firewall-cmd --complete-reload

systemclt enable sshd.service
yum -y remove epel-release
yum --enablerepo=* clean all
yum -y install katello foreman openldap-clients katello-utils puppet

mkdir ~/.hammer
chmod 600 ~/.hammer
echo ":foreman:" > ~/.hammer/cli_config.yml
echo "    :host: 'https://ecf-sat6.fnal.gov/'" >> ~/.hammer/cli_config.yml
echo "    :username: 'admin'" >> ~/.hammer/cli_config.yml
echo "    :password: '${DEFAULT_ADMIN_PASSWORD}'" >> ~/.hammer/cli_config.yml

katello-installer --foreman-admin-username admin --foreman-admin-password password

firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 0 -o lo -p tcp -m tcp --dport 9200 -m owner --uid-owner foreman -j ACCEPT \
&& firewall-cmd --permanent --direct --add-rule ipv6 filter OUTPUT 0 -o lo -p tcp -m tcp --dport 9200 -m owner --uid-owner foreman -j ACCEPT \
&& firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 0 -o lo -p tcp -m tcp --dport 9200 -m owner --uid-owner root -j ACCEPT \
&& firewall-cmd --permanent --direct --add-rule ipv6 filter OUTPUT 0 -o lo -p tcp -m tcp --dport 9200 -m owner --uid-owner root -j ACCEPT \
&& firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 1 -o lo -p tcp -m tcp --dport 9200 -j DROP \
&& firewall-cmd --permanent --direct --add-rule ipv6 filter OUTPUT 1 -o lo -p tcp -m tcp --dport 9200 -j DROP \
&& firewall-cmd --complete-reload

# Do all of this AFTER katello-installer runs to ensure things don't get removed
# per https://access.redhat.com/documentation/en-US/Red_Hat_Satellite/6.1/html/Installation_Guide/sect-Red_Hat_Satellite-Installation_Guide-Prerequisites.html#sect-Red_Hat_Satellite-Installation_Guide-Prerequisites-Large_deployments
echo 'vm.max_map_count = 655300' > /etc/sysctl.d/50-sat6-install.conf
echo 'fs.aio-max-nr = 59400' >> /etc/sysctl.d/50-sat6-install.conf
echo "max-connections=1300" >> /etc/qpid/qpidd.conf

echo '.include /lib/systemd/system/qpidd.service' > /etc/systemd/system/qpidd.service
echo '[Service]' >> /etc/systemd/system/qpidd.service
echo 'LimitNOFILE=3000' >> /etc/systemd/system/qpidd.service
echo 'Nice=1' >> /etc/systemd/system/qpidd.service

echo '.include /usr/lib/systemd/system/foreman-tasks.service' > /etc/systemd/system/foreman-tasks.service
echo '[Service]' >> /etc/systemd/system/foreman-tasks.service
echo 'Nice=-1' >> /etc/systemd/system/foreman-tasks.service

echo '.include /usr/lib/systemd/system/httpd.service' > /etc/systemd/system/httpd.service
echo '[Service]' >> /etc/systemd/system/httpd.service
echo 'Nice=-1' >> /etc/systemd/system/httpd.service


