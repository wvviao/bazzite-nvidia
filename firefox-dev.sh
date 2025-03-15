#!/usr/bin/bash

set ${SET_X:+-x} -eou pipefail

# https://github.com/the4runner/firefox-dev

dnf5 -y copr enable the4runner/firefox-dev
mv /opt{,.bak} && mkdir /opt
dnf5 -y install firefox-dev
mv /opt/firefox-dev /usr/lib/firefox-dev

mv /opt{.bak,}
