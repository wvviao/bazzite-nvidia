#!/usr/bin/bash
#shellcheck disable=SC2115

set ${SET_X:+-x} -eou pipefail

repos=(
    google-chrome
    vscode
    resilio-sync
)

for repo in "${repos[@]}"; do
    if [[ -f "/etc/yum.repos.d/{$repo}.repo" ]]; then
        sed -i 's@enabled=1@enabled=0@g' "/etc/yum.repos.d/{$repo}.repo"
    fi
done

COPR_REPOS=(
    zeno/scrcpy
    the4runner/firefox-dev
)

for repo in "${COPR_REPOS[@]}"; do
    dnf5 -y copr disable "${repo}"
done

dnf5 clean all

rm -rf /tmp/*
rm -rf /var/*
ostree container commit
mkdir -p /tmp
mkdir -p /var/tmp && chmod -R 1777 /var/tmp
