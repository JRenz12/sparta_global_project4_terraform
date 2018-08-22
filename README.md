# sparta_global_project4_terraform


#initiate main db (db_1a, 10.10.4.7)
after terraform apply log in to mongo db using below mongo command

mongo mongodb://${db1}/rs0

use rs initiate command to add members to the replica set
rs.initiate({ _id: "rs0", members: [ { _id: 0, host : "10.10.4.7" }, { _id: 1, host : "10.10.5.7" }, { _id: 2, host : "10.10.6.7" } ] })

set db as master so it can change settings
db.isMaster()

set read permissions for secondaries to ok
rs.slaveOk()

quit mongo shell
quit()

start mongod service
sudo service mongod start
