#!/bin/bash

export LC_ALL=C

sudo mkdir ./db0
sudo chmod 755 ./db0
mongo
rs.initiate()
rs.initiate({ _id: "rs0", members: [ { _id: 0, host : "10.10.4.7" }, { _id: 1, host : "10.10.5.7" }, { _id: 2, host : "10.10.6.7" } ] })
db.isMaster()
rs.slaveOk()
quit()
sudo mongod --replSet rs0 --port 27017 --dbpath ./db0 —bind_ip localhost, 10.10.4.7
sudo service mongod start
