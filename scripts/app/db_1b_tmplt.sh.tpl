#!/bin/bash

export LC_ALL

sudo mkdir ./db0
sudo chown chmod 755 ./dbo
sudo mongod --replSet rs0 --port 27017 --dbpath ./db0 —bind_ip localhost, 10.10.4.7
