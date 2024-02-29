#!/bin/sh

WIS2NODE=$1

cd /home/ansadm/data

if [ -f env/`echo $WIS2NODE`broker.env ]; then
  rm -rf env/`echo $WIS2NODE`broker.env
fi


if [ -d wis2node/$WIS2NODE ]; then
  rm -rf wis2node/$WIS2NODE
fi

if [ -f json/$WIS2NODE.json ]; then
  rm json/`echo $WIS2NODE`.json
  if [ "$(ls -A json)" ]; then
     jq -n 'reduce inputs as $in (null;
        . + if $in|type == "array" then $in else [$in] end)
        ' $(find ./json -name '*.json') > mqtt.json
  else
     cat /dev/null > mqtt.json
  fi
fi
