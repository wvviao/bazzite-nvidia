#!/usr/bin/bash

set ${SET_X:+-x} -eou pipefail

# VSCode because it's still better for a lot of things
tee /etc/yum.repos.d/vscode.repo <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

$DNF install --setopt=install_weak_deps=False -y \
    code

# SYSEXTS https://github.com/travier/fedora-sysexts
install -d -m 0755 -o 0 -g 0 /var/lib/extensions /var/lib/extensions.d /etc/sysupdate.d
restorecon -RFv /var/lib/extensions /var/lib/extensions.d /etc/sysupdate.d
SYSEXT="google-chrome"
RELEASE_TAG="fedora-kinoite-41"
URL="https://github.com/travier/fedora-sysexts/releases/download/${RELEASE_TAG}/${SYSEXT}.conf"
curl --silent --location "${URL}" | tee "/etc/sysupdate.d/${SYSEXT}.conf"
/usr/lib/systemd/systemd-sysupdate update
systemctl restart systemd-sysext.service
