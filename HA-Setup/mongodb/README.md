<!--
#### Step 1: Install Mongodb on each VM
#### Step 2: Config 
- Run the command below to access the config file, copy the config from master folder the restart to apply the config
```ruby
nano /etc/mongod.conf

systemctl restart mongod
```
#### Step 3: Setup
- Log in to the primary node 192.168.56.203 .

```ruby
mongo
> rs.initiate()
```

- add replica:
```
rs.add(“mongo-db2:27017”)
rs.add(“mongo-db3:27017”)
```

Once you add the nodes, you will see the output as {‘ok’:1}, which indicates a successful addition of nodes in the replica set.

#### Step 4; Check
```ruby
rs.status()
```

If you're got sth like this, congrats

```
{ 
"set" : "myitsocial", 
"date" : ISODate("2022-02-10T06:15:02Z"), 
"myState" : 1, 
"members" : [ 
   { 
      "_id" : 0, 
      "name" : "192.168.0.29:27017", 
      "health" : 1, 
      "state" : 1, 
      "stateStr" : "PRIMARY", 
      "uptime" : 303165, 
      "optime" : Timestamp(1644516902, 1), 
      "optimeDate" : ISODate("2022-02-10T06:15:02Z"), 
      "self" : true 
   }, 
   { 
      "_id" : 1, 
      "name" : "192.168.0.30:27017", 
      "health" : 1, 
      "state" : 2, 
      "stateStr" : "SECONDARY", 
      "uptime" : 302985, 
      "optime" : Timestamp(1644516902, 1), 
      "optimeDate" : ISODate("2022-02-10T06:15:02Z"), 
      "lastHeartbeat" : ISODate("2022-02-10T06:15:02Z"), 
      "lastHeartbeatRecv" : ISODate("2014-08-12T06:15:02Z"), 
      "pingMs" : 0, 
   "syncingTo" : "10.20.30.40:27017" 
   },
   { 
      "_id" : 2, 
      "name" : "192.168.0.31:27017", 
      "health" : 1, "state" : 2, 
      "stateStr" : "SECONDARY", 
      "uptime" : 302985, 
      "optime" : Timestamp(1644516902, 1), 
      "optimeDate" : ISODate("2022-02-10T06:15:02Z"), 
      "lastHeartbeat" : ISODate("2022-02-10T06:15:02Z"), 
      "lastHeartbeatRecv" : ISODate("2022-02-10T06:15:02Z"), 
      "pingMs" : 0, 
      "syncingTo" : "192.168.0.29:27017" 
   } 
], 
"ok" : 1 
} 
```
-->
