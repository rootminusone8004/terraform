#!/bin/bash

set -e

USERNAME="${username}"

# Create user
if ! id "$USERNAME" >/dev/null 2>&1; then
    useradd -m -s /bin/bash "$USERNAME"
fi

# Give sudo access
usermod -aG sudo "$USERNAME"

# Configure SSH directory
mkdir -p "/home/$USERNAME/.ssh"
chmod 700 "/home/$USERNAME/.ssh"

cat > "/home/$USERNAME/.ssh/authorized_keys" <<'EOF'
${ssh_public_key}
EOF

chmod 600 "/home/$USERNAME/.ssh/authorized_keys"
chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.ssh"

# Passwordless sudo
cat > "/etc/sudoers.d/$USERNAME" <<EOF
$USERNAME ALL=(ALL) NOPASSWD:ALL
EOF

chmod 440 "/etc/sudoers.d/$USERNAME"

# SSH hardening
cat > /etc/ssh/sshd_config.d/terraform-hardening.conf <<EOF
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
EOF

sshd -t
systemctl restart ssh
