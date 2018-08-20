#!/bin/bash

export LC_ALL=c
sudo mkdir ./posts
sudo chown -R $USER ./posts
sudo mongod --port 27019 --dbpath ./posts --replSet rs0 --bind_ip localhost, 15.10.4.7
