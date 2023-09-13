#!/bin/env dash

# Description: Automate building the ISO
# Version: v1.0

# Safer script
set -o errexit
set -o nounset
trap "exit" INT

# Variables
parent=$(pwd)

# Cleanup
cleanup () {
    rm -fr "$parent"/archiso-base "$parent"/work "$parent"/out
}

# Fetch and patch files
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
    cd "$parent"/archiso-base # to fix errors while creating temporary files
    sudo mkarchiso -v configs/releng
}

# Actually do stuffs
cleanup
setup
repo
build
