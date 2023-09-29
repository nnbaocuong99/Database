#### Step 1: Install MariaDB on each VM

#### Step 2: Configure
- run this command:
```ruby
sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf
```
- For the master Copy the `mariadb.cnf` inthe master folder or find and modify the following lines:

```ruby
[mysqld]
server-id = 1          # Unique ID for the master
log-bin = /var/log/mysql/mysql-bin.log
binlog_do_db = your_database_name
```

#### Step 3: Restart to apply the config
```ruby
sudo systemctl restart mariadb
```

#### Step 4: Config the master node
- Login:
```
sudo mysql -u root -p
```
- Create replication user:
```ruby
CREATE USER 'replication_user'@'%' IDENTIFIED BY 'password';
GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'%';
FLUSH PRIVILEGES;
EXIT;
```

> You can create a consistent backup of the master database using your preferred method (e.g., mysqldump, XtraBackup) and transfer the backup file to the slave server.

#### Step 5: Config the slave node

- Copy the `mariadb.cnf` in the slave folder or find and modify the following lines:
```
[mysqld]
server-id = 2          # Unique ID for the slave
```
- Access into slave not with the same command as master node
- Run those command and config as yours
```
CHANGE MASTER TO MASTER_HOST='master_ip_address',
MASTER_USER='replication_user',
MASTER_PASSWORD='password',
MASTER_LOG_FILE='binlog_file_from_master',
MASTER_LOG_POS=binlog_position_from_master;
```

- Run the slave, check slave:
```
START SLAVE;
SHOW SLAVE STATUS \G;
```