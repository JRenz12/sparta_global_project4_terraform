#!/bin/bash

mongod --replSet "rs0" --bind_ip localhost, 10.10.5.7

## send a string to mongo and run it as a script.
