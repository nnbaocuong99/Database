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

