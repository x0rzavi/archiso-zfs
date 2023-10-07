#!/bin/env dash

# Description: Update local repo packages
# Dependencies: paru

# Safer script
set -o errexit
set -o nounset
trap "exit" INT

# Variables
parent=$(pwd)

# Cleanup
cleanup () {
    rm -fr "$parent"/build ; mkdir "$parent"/build
    rm -fr "$parent"/repo ; mkdir "$parent"/repo
}

# Fetch pkgbuilds
fetch () {
    cd "$parent"/build
    paru -G nbfc-linux
}

# Make pkgbuilds
build () {
    for dir in "$parent"/build/*; do
        cd "$dir"
        env EUID=1 makepkg -s # hack to bypass denial if root detected
        mv "$dir"/*.pkg.tar.zst "$parent"/repo
    done
}

# Add to repo
repo () {
    for file in "$parent"/repo/*; do
        repo-add "$parent"/repo/repo.db.tar.gz "$file"
    done
    cd "$parent"
    sed -i "101 s|Server.*|Server = file://$(pwd)/repo|" "$parent"/archiso-base/configs/releng/pacman.conf
}

# Actually do stuffs
cleanup
fetch
build
repo
