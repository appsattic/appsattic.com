#!/bin/bash
## --------------------------------------------------------------------------------------------------------------------

set -e

echo "Checking ask.sh is installed ..."
if [ ! /home/chilts/bin/ask.sh ]; then
    echo "Please put ask.sh into ~/bin (should already be in your path from ~/.profile):"
    echo ""
    echo "    mkdir ~/bin"
    echo "    wget -O ~/bin/ask.sh https://gist.githubusercontent.com/chilts/6b547307a6717d53e14f7403d58849dd/raw/ecead4db87ad4e7674efac5ab0e7a04845be642c/ask.sh"
    echo "    chmod +x ~/bin/ask.sh"
    echo ""
    exit 2
fi
echo

# General
APPSATTIC_PORT=`ask.sh pow APPSATTIC_PORT 'Which local port should the server listen on (e.g. 9670):'`
APPSATTIC_APEX=`ask.sh pow APPSATTIC_APEX 'What is the apex (e.g. localhost:9670 or appsattic.com) :'`
APPSATTIC_BASE_URL=`ask.sh pow APPSATTIC_BASE_URL 'What is the base URL (e.g. http://localhost:1234 or https://appsattic.com) :'`

echo "Building code ..."
gb build
echo

# copy the supervisor script into place
echo "Copying supervisor config ..."
m4 \
    -D __APPSATTIC_PORT__=$APPSATTIC_PORT \
    -D __APPSATTIC_APEX__=$APPSATTIC_APEX \
    -D __APPSATTIC_BASE_URL__=$APPSATTIC_BASE_URL \
    etc/supervisor/conf.d/appsattic.conf.m4 | sudo tee /etc/supervisor/conf.d/.conf
echo

# restart supervisor
echo "Restarting supervisor ..."
sudo systemctl restart supervisor.service
echo

# copy the caddy conf
echo "Copying Caddy config config ..."
m4 \
    -D __APPSATTIC_PORT__=$APPSATTIC_PORT \
    -D __APPSATTIC_APEX__=$APPSATTIC_APEX \
    -D __APPSATTIC_BASE_URL__=$APPSATTIC_BASE_URL \
    etc/caddy/vhosts/appsattic.conf.m4 | sudo tee /etc/caddy/vhosts/appsattic.conf
echo

# restarting Caddy
echo "Restarting caddy ..."
sudo systemctl restart caddy.service
echo

## --------------------------------------------------------------------------------------------------------------------
