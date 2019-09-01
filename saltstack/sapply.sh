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

