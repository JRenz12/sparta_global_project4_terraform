# Project4 Terraform


After terraform apply log in to mongo db using below mongo command and add the public IP of the primary DB instance. 

`mongo mongodb://{public_ip}`

Use rs.initiate command to add members to the replica set.

`rs.initiate({ _id: "rs0", members: [ { _id: 0, host : "10.10.4.7" }, { _id: 1, host : "10.10.5.7" }, { _id: 2, host : "10.10.6.7" } ] })`

Set db as master so it can change settings.

`db.isMaster()`

Set read permissions for secondaries to ok.

`rs.slaveOk()`

Quit mongo shell.

`quit()`

Start mongod service.

`sudo service mongod start`
