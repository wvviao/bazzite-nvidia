#!/usr/bin/bash

set ${SET_X:+-x} -eou pipefail

COPR_REPOS=(
    zeno/scrcpy
    the4runner/firefox-dev
)

for repo in "${COPR_REPOS[@]}"; do
    dnf5 -y copr enable "${repo}"
done

COPR_PACKAGES=(
    scrcpy
)

dnf5 install --setopt=install_weak_deps=False -y "${COPR_PACKAGES[@]}"

/ctx/firefox-dev.sh
