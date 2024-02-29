#!/bin/sh

CONTAINERTAG=$1

if [ -z "$CONTAINERTAG" ]
then
    echo "Usage: $0 <container-tag>"
fi

for centreid in `./get-container-tag.sh $CONTAINERTAG | cut -d'/' -f 3`; do
    echo ./add_wis2node.sh $centreid
    echo  ansible-playbook update-wis2node.yml -e "wis2node=$centreid"
done
