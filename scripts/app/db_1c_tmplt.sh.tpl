#!/bin/bash

mongod --port 27017 --dbpath /srv/mongodb/db0 --replSet rs0  --bind_ip localhost, 10.10.6.7

rs.slaveOk()
