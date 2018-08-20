#!/bin/bash
export LC_ALL=c
sudo mkdir ./db0 ./db1 ./db2
sudo chown -R $USER ./db0 ./db1 ./db2
sudo mongod --port 27018 --dbpath ./db0 --replSet rs0 --bind_ip localhost, 15.10.4.7
