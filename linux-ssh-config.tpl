cat << EOF >> ~/.ssh/config

Host ${hostname}
  Hostname ${hostname}
  User ${user}
  IdentityFile ${identityFile}
EOF

rm env
touch env
echo usr=${user} >> env
echo IP=${hostname} >> env

