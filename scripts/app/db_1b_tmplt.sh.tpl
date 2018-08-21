#!/bin/bash

export LC_ALL=C

sudo mkdir ./posts
sudo chown chmod 755 ./posts

mongod --replSet rs0 --port 27017 --dbpath ./posts —bind_ip localhost,0.0.0.0
