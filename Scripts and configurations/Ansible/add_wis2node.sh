!/bin/sh

WIS2NODE=$1

cd /home/ansadm/data

if [ ! -d "wis2node/$WIS2NODE" ]; then
  mkdir wis2node/$WIS2NODE
fi

#1 Create traefik rule for waloop
cp wis2node_waloop.yml `echo $WIS2NODE`_waloop.yml
sed -i "s/wis2node/$WIS2NODE/g" `echo $WIS2NODE`_waloop.yml
mv  `echo $WIS2NODE`_waloop.yml wis2node/$WIS2NODE

#2 Create traefik rule for wmanage
cp wis2node_wmanage.yml `echo $WIS2NODE`_wmanage.yml
sed -i "s/wis2node/$WIS2NODE/g" `echo $WIS2NODE`_wmanage.yml
MY_IP=`nslookup gaya.giraud.me 2>/dev/null  | grep "Address: " | sed 's/.*: //g;s/ .*//g'`\/32
sed -i "s%gaya%$MY_IP%g" `echo $WIS2NODE`_wmanage.yml
mv  `echo $WIS2NODE`_wmanage.yml wis2node/$WIS2NODE

#3 Create prometheus entry
cp wis2node_mqtt.json json/`echo $WIS2NODE`.json
sed -i "s/wis2node/$WIS2NODE/g" json/`echo $WIS2NODE`.json 
jq -n 'reduce inputs as $in (null;
    . + if $in|type == "array" then $in else [$in] end)
    ' $(find ./json -name '*.json') > mqtt.json

#4 Create directory and compose entries
if [ ! -d "wis2node/$WIS2NODE/compose" ]; then
  mkdir wis2node/$WIS2NODE/compose
fi

cp wis2node-docker-compose.yml wis2node/$WIS2NODE/compose/docker-compose.yml
sed -i "s/wis2node/$WIS2NODE/g" wis2node/$WIS2NODE/compose/docker-compose.yml
cp globalenv/globalbroker.env wis2node/$WIS2NODE/compose
cp globalenv/redis.env wis2node/$WIS2NODE/compose
cp env/`echo $WIS2NODE`.env wis2node/$WIS2NODE/compose
