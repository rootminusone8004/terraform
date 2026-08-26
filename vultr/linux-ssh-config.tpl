cat << EOF >> ~/.ssh/config

Host ${hostname}
  Hostname ${hostname}
  User ${user}
  ForwardX11 yes
  ForwardX11Trusted yes
  IdentityFile ${identityFile}
EOF

rm env
touch env
cat ~/.vultr/env >> env
echo usr=${user} >> env
echo IP=${hostname} >> env

