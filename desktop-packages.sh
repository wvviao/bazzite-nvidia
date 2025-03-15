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

dnf5 install --setopt=install_weak_deps=False -y \
    code

# Simplenote https://github.com/Automattic/simplenote-electron/releases
/ctx/github-release-install.sh Automattic/simplenote-electron x86_64
/ctx/google-chrome.sh
