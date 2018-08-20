#!/bin/bash

sudo mkdir ./db0 ./db1 ./db2
sudo chown -R $USER ./db0 ./db1 ./db2
sudo mongod --port 27017 --dbpath ./db0 --replSet rs0 --bind_ip localhost, 10.10.4.7
