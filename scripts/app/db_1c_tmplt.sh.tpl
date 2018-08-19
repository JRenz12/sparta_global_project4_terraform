#!/bin/bash

mongod --dbpath /srv/mongodb/db0 --replSet rs0  --bind_ip localhost, 10.10.4.7

mongo
rs.slaveOk()

## send a string to mongo and run it as a script.
