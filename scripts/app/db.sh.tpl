#!/bin/bash

Sudo mkdir ./db0
Sudo chown $USER ./dbo

Sudo mongod --port 27017 --dbpath ./db0 --replSet rs0 --bind_ip localhost, 10.10.4.7
sudo service mongod start
