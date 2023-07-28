# Setup mongodb Replicaset

### labs setup
| ID | Role      | Hostname | IP             | port |
|----|-----------|--------- |----------------|------|
| 0  | primary   | db1      | 192.168.56.210 |
| 1  | secondary | db2      | 192.168.56.211 |
| 2  | secondary | db3      | 192.168.56.212 |

### 1. Setup VM 
- Use [this]() script to setup at least 3 VM
- Use `vagrant up` to creat a VM and install mongodb on each node (requirements 2 CPU, 4GB RAM)

<br>

### 2. Install commands

#### Update Ubuntu
Update the package lists and upgrade the installed packages to their latest versions
```ruby
$ sudo apt update
$ sudo apt upgrade
```

#### Import the MongoDB GPG Key
Run this command to import the MongoDB GPG key, which will verify the integrity of the packages:
```ruby
$ wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
```

#### Add MongoDB repository
Create a list file for MongoDB and update the list again with the following command:

```bash
$ echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
$ sudo apt update
```

### Install MongoDB
Install MongoDB. In this case im using specifics version for Mongodb is 4.4.23
```ruby
$ sudo apt-get install -y mongodb-org=4.4.23 mongodb-org-server=4.4.23 mongodb-org-shell=4.4.23 mongodb-org-mongos=4.4.23 mongodb-org-tools=4.4.23
```

### Start MongoDB and enable it on boot:
```ruby
$ sudo systemctl start mongod
$ sudo systemctl enable mongod
```

### Verify MongoDB installation:
Check the status of the MongoDB service to ensure it is running:
```ruby
$ sudo systemctl status mongod
```

<br>

### 3. Setup multi-instances
- Create directories:
  ```
  mkdir -p storage/data/db1
  mkdir -p storage/data/db2
  mkdir -p storage/data/db3
  ```

- Start mongdod instance:
  ```
  mongod --port 27017 --dbpath storage/data/db1 --replSet mrs
  ```
