#!/usr/bin/bash

set ${SET_X:+-x} -eou pipefail

# Simplenote https://github.com/Automattic/simplenote-electron/releases
mv /opt{,.bak} && mkdir /opt
/ctx/github-release-install.sh Automattic/simplenote-electron x86_64
mv /opt/Simplenote /usr/lib/Simplenote
ln -sf /usr/lib/Simplenote/simplenote /usr/bin/simplenote
sed -i 's@/opt/Simplenote/simplenote@/usr/bin/simplenote@g' "/usr/share/applications/simplenote.desktop"
mv /opt{.bak,}
