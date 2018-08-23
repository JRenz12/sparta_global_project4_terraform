# Project4 Terraform

After terraform apply open a terminal window and execute the follow commands.

`mongo mongodb://{public_ip}`

The following block explained:

Use rs.initiate command to declare the DB instances by it's private IP, as primary or secondary sets.
Secondary sets are the replica sets.

Set DB as master so it can change settings.

Set read permissions for the secondaries set to ok.

Quit mongo shell.

```
#!/bin/mongo
mongo mongodb://${public_ip}/rs0 --eval "rs.initiate()"
mongo mongodb://${public_ip}/rs0 --eval "rs.add('10.10.5.7')"
mongo mongodb://${public_ip}/rs0 --eval "rs.add('10.10.6.7')"
mongo mongodb://${public_ip}/rs0 --eval "db.isMaster()"
mongo mongodb://${public_ip}/rs0 --eval "rs.slaveOk()"

```

#### Link to application:
`eng12.spartaglobal.education`

#### Link to view database:
`eng12.spartaglobal.education/posts`

## ELK

**Elastisearch:** `eng12.spartaglobal.education:9200`

**LogStash:** `eng12.spartaglobal.education:5043`

**Kimbana:** `eng12.spartaglobal.education:5601`
