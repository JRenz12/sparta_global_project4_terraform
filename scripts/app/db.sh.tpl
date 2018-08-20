#!/bin/bash
export LC_ALL=c
sudo mkdir ./db0 ./db1 ./db2
sudo chown -R $USER ./db0 ./db1 ./db2
sudo mongo --port 27017

rs.initiate({ _id: "rs0", members: [ { _id: 0, host : "15.10.4.7:27017" }, { _id: 1, host : "15.10.4.7:27018" }, { _id: 2, host : "15.10.4.7:27019" } ] })
db.isMaster()
rs.slaveOk()
quit()

mongod --port 27017 --dbpath ./db0 --replSet rs0 --bind_ip localhost, 15.10.4.7
