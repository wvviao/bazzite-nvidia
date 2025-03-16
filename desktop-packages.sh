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

# Resilio Sync
# https://help.resilio.com/hc/en-us/articles/206178924-Installing-Sync-package-on-Linux
tee /etc/yum.repos.d/resilio-sync.repo <<'EOF'
[resilio-sync]
name=Resilio Sync
baseurl=https://linux-packages.resilio.com/resilio-sync/rpm/\$basearch
enabled=1
gpgcheck=1
gpgkey=https://linux-packages.resilio.com/resilio-sync/key.asc
EOF

dnf5 install --setopt=install_weak_deps=False -y \
    code \
    resilio-sync

/ctx/simplenote.sh
/ctx/google-chrome.sh
