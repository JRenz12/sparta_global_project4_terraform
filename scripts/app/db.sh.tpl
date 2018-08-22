#!/usr/bin/bash
export LC_ALL=C
sudo chown $USER /var/lib/mongodb
sudo mongod --replSet rs0 --dbpath /var/lib/mongodb --fork --logpath /var/log/mongodb.log
sudo mongo --eval 'rs.initiate({ _id: "rs0", members: [ { _id: 0, host : "10.10.4.7" }, { _id: 1, host : "10.10.5.7" }, { _id: 2, host : "10.10.6.7" } ] })'
sudo mongo --eval 'db.isMaster()'
sudo mongo --eval 'rs.slaveOk()'
sudo service mongod start
