# Project4 Terraform


After terraform apply log in to mongo db using below mongo command and add the public IP of the primary DB instance. 

`mongo mongodb://{public_ip}`

Use rs.initiate command to declare the DB instances by it's private IP, as primary or secondary sets.
Secondary sets are the replica sets.

`rs.initiate({ _id: "rs0", members: [ { _id: 0, host : "10.10.4.7" }, { _id: 1, host : "10.10.5.7" }, { _id: 2, host : "10.10.6.7" } ] })`

Set DB as master so it can change settings.

`db.isMaster()`

Set read permissions for the secondaries set to ok.

`rs.slaveOk()`

Quit mongo shell.

`quit()`

ELK
**Elastisearch: `eng12.spartaglobal.education:9200`
**Log Stash: `eng12.spartaglobal.education:5043`
**Kimbana:** `eng12.spartaglobal.education:5601`
