#!/usr/bin/env bash

sudo apt-get update
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.26.1/install.sh | bash
source ~/.nvm/nvm.sh
nvm install node
nvm alias default node

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo service mongod start

sudo apt-get install -y nginx

sudo rm /etc/nginx/sites-available/default
sudo touch /etc/nginx/sites-available/default

sudo cat >> /etc/nginx/sites-available/default <<'EOF'

server {
    listen 8080;

    location / {
        proxy_pass http://localhost:4000;
    }
}

server {
    listen 80;

    location / {
        proxy_pass http://localhost:4000;
    }
}

EOF

sudo service nginx restart

screen -dm bash -c "cd /vagrant; node index.js;"

# cd /vagrant
# npm install
# npm install -g nodemon
# nohup node index.js &

# sudo apt-get install -y ruby
# sudo gem install foreman
# sudo foreman export upstart /etc/init -a nodejs -u vagrant -p 4000
# sudo service nodejs start