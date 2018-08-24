#!/bin/sh

mongo mongodb://${public_ip}/rs0 --eval "rs.initiate()"
mongo mongodb://${public_ip}/rs0 --eval "rs.add( '10.10.5.7' )"
mongo mongodb://${public_ip}/rs0 --eval "rs.add( '10.10.6.7' )"
mongo mongodb://${public_ip}/rs0 --eval "db.isMaster()"
mongo mongodb://${public_ip}/rs0 --eval "rs.slaveOk()"
