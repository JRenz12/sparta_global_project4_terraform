#!/bin/bash
export LC_ALL=c
mongo --host ${db1}/rs0 db0

#!/bin/mongo
rs.initiate({ _id: "rs0", members: [ { _id: 0, host : "15.10.4.7" }, { _id: 1, host : "15.10.5.7" }, { _id: 2, host : "15.10.6.7" } ] })
db.isMaster()
rs.slaveOk()
quit()
