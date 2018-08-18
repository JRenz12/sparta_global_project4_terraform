#!/bin/bash

mongo --host 10.10.4.7
rs.initiate()
rs.add(“10.10.5.7”)
rs.addArb(“10.10.6.7”)

## send a string to mongo and run it as a script.
rs.slaveOk()
