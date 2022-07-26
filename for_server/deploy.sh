#! /bin/bash

echo
echo "======================="
echo "* Starting deployment *"
echo "======================="
echo

sudo unzip -o /home/ubuntu/tmp/for-deployment.zip -d /srv/shiny-server/biodiversity-dashboard
echo
sudo service shiny-server restart
sudo service shiny-server status
echo
sudo service nginx restart
sudo service nginx status

echo 
echo "-----------------------"
echo "* Deployment finished *"
echo "-----------------------"
