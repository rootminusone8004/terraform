#!/bin/sh

set -eu

USERNAME="${username}"
SSH_PUBLIC_KEY='${ssh_public_key}'

echo "==> Creating user: $USERNAME"

if ! id "$USERNAME" >/dev/null 2>&1; then
    useradd -m -s /bin/ksh "$USERNAME"
fi

echo "==> Adding $USERNAME to wheel"

usermod -G wheel "$USERNAME"

echo "==> Installing SSH key"

install -d -m 700 \
    -o "$USERNAME" \
    -g "$USERNAME" \
    "/home/$USERNAME/.ssh"

printf '%s\n' "$SSH_PUBLIC_KEY" \
    > "/home/$USERNAME/.ssh/authorized_keys"

chmod 600 "/home/$USERNAME/.ssh/authorized_keys"

chown "$USERNAME:$USERNAME" \
    "/home/$USERNAME/.ssh/authorized_keys"

echo "==> Configuring doas"

cat > /etc/doas.conf <<EOF
permit persist :wheel
EOF

chmod 600 /etc/doas.conf

echo "==> Hardening SSH"

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' \
    /etc/ssh/sshd_config

sed -i 's/^#*KbdInteractiveAuthentication.*/KbdInteractiveAuthentication no/' \
    /etc/ssh/sshd_config

sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' \
    /etc/ssh/sshd_config

echo "==> Checking sshd configuration"

sshd -t

echo "==> Restarting sshd"

rcctl restart sshd

echo "==> Bootstrap complete"
echo "==> SSH user: $USERNAME"
