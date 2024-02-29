#!/bin/sh

# Get all image versions
# Usage $0 <optional version>

CONTAINERTAG=$1

cd /home/ansadm/data/ && grep -r "image: $CONTAINERTAG" ./wis2node/
