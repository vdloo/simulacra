#!/bin/bash
set -e

ROLE=common  # in case no -r <role> is specified
while getopts "r:" opt; do
    case $opt in
        r) ROLE=$OPTARG;;
    esac
done

echo "Configuring machine as role $ROLE"

# https://docs.saltstack.com/en/latest/topics/tutorials/quickstart.html
WORKING_DIR=`pwd`
if test ! -e bootstrap_salt.sh; then
    echo "Installing SaltStack"
    curl -L https://bootstrap.saltstack.com -o bootstrap_salt.sh
    sh bootstrap_salt.sh
else
    echo "SaltStack already installed"
fi

# Writing salt grains
cat <<EOF > /etc/salt/grains
role: $ROLE
EOF

echo "Install salt formulas"
rm -rf formulas
mkdir -p /srv/formulas
cd /srv/formulas
# Currently no salt formulas in use
cd $WORKING_DIR

# Masterless Salt https://docs.saltstack.com/en/latest/topics/tutorials/quickstart.html
cat <<EOF > /etc/salt/minion
file_client: local
file_roots:
  base:
    - /srv/salt
    - /srv/formulas/*
EOF

systemctl restart salt-minion

for saltdir in salt pillar; do
    echo "Installing $saltdir files"
    rm -rf /srv/$saltdir
    cp -R $saltdir /srv/$saltdir
done

echo "Applying state"
salt-call --local state.apply -l error --state-output=mixed --force-color
