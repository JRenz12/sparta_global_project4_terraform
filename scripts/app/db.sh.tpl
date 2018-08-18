#!/bin/bash

mongo
rs.initiate(
   {
      _id: "rs0",
      members: [
         { _id: 0, host : ${db_1a_privateip} },
         { _id: 1, host : ${db_1b_privateip} },
         { _id: 2, host : ${db_1c_privateip} }
      ]
   }
)

## send a string to mongo and run it as a script.
