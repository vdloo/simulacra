#!/bin/bash
# https://docs.saltstack.com/en/latest/topics/tutorials/quickstart.html
if test ! -e bootstrap_salt.sh; then
    echo "Installing SaltStack"
    curl -L https://bootstrap.saltstack.com -o bootstrap_salt.sh
    sh bootstrap_salt.sh
else
    echo "SaltStack already installed"
fi

# Masterless Salt https://docs.saltstack.com/en/latest/topics/tutorials/quickstart.html
cat <<EOF > /etc/salt/minion
file_client: local
EOF

systemctl restart salt-minion

for saltdir in salt pillar; do
    echo "Installing $saltdir files"
    rm -rf /srv/$saltdir
    cp -R $saltdir /srv/$saltdir
done

echo "Applying state"
salt-call --local state.apply -l debug --force-color
