#!/bin/bash

export LC_ALL=C

sudo mkdir ./posts
sudo chmod 755 ./posts

mongo <<EOF
rs.initiate({ _id: "rs0", members: [ { _id: 0, host : "10.10.4.7" }, { _id: 1, host : "10.10.5.7" }, { _id: 2, host : "10.10.6.7" } ] })
db.isMaster()
rs.slaveOk()
quit()
EOF
mongod --replSet rs0 --port 27017 --dbpath ./posts —bind_ip localhost, 0.0.0.0
sudo service mongod start
