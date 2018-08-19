#!/bin/bash
mongod --port 27017 --dbpath /srv/mongodb/db0 --replSet rs0 --bind_ip localhost,10.10.4.7

rs.initiate( {
   _id : "rs0",
   members: [
      { _id: 0, host: "10.10.4.7:27017" },
      { _id: 1, host: "10.10.5.7:27017" },
      { _id: 2, host: "10.10.6.7:27017" }
   ]
})
db.isMaster()
rs.slaveOk()
