#!/bin/bash

mongo
rs.initiate(
   {
      _id: "rs0",
      members: [
         { _id: 0, host : "http://10.10.4.7" },
         { _id: 1, host : "http://10.10.5.7" },
         { _id: 2, host : "http://10.10.6.7" }
      ]
   },

## send a string to mongo and run it as a script.
