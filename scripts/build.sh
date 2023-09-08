#!/bin/env dash

# Description: Automate building the ISO

# Safer script
set -o errexit
set -o nounset
trap "exit" INT

# Variables
parent=$(pwd)

# Cleanup
cleanup () {
    rm -fr archiso-base work out
}

# Fetch and setup files
setup () {
    git clone https://github.com/x0rzavi/archiso-zfs.git --branch base --depth=1 archiso-base
    cd "$parent"/archiso-base
    git apply "$parent"/patches/*
}

# Setup local repo
repo () {
    cd "$parent"
    "$parent"/scripts/local_repo.sh
}

# Build the ISO
build () {
    sudo mkarchiso -v "$parent"/archiso-base/configs/releng
}

# Actually do stuffs
cleanup
setup
repo
build
