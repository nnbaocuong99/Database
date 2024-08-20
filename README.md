###### <div align="center"> © Spagbo 26 May, 2023 // 2022-2024 </div>

<br>

# ❗️ Introducing

### ✨<ins>***1. Credit & Usage // Sumary***</ins>:
***About the project:***
- This project will show you 100% on-prem, basically how to Install MongoDB & MariaDB using `Helm chart` and `ArgoCD`. Also *deploy, backup and restore data* on it.
- This project is exactly the second part of the K8s one and includes work on both Kubernetes (K8s) and VPS.

***Credit***
- This project is written by me and wouldn't be possible without the hard work and contributions of the following individuals: [@QuocNVC](https://github.com/quoc9x) - Bug fixes and enhancements, [@TruongLM](https://github.com/lmt2407) - VM script writer.
- For ***<mark><ins>Learning-purposes Only***</mark></ins>, meant for educational and non-commercial use. Feel free to study, learn from it.
- Has ***<mark><ins>No Unauthorized Copying***</mark></ins>. Please refrain from directly copying or using it for any commercial or production purposes without proper authorization.
- If you find this project helpful, consider giving credit by linking back to this repository. Mentioning it in your own project's documentation or `README` is appreciated.

<br>

### ✨<ins>***2. Todo list, Table of contents***</ins>:
***On K8s***
- [x] Deloy Database on k8s:
- [ ] ~~Mongodb~~
- [x] Mariadb
- [x] Pratices / Dump data

***On VPS***
- [x] Deploy Database on VPS:
- [x] Mongodb
- [x] Mariadb

***Advanced, Optional***
- [x] Covert, install Replicaset, Masterslave

---

<br>

# ❗️ Guides
### ✨ Setup
- Firstly! as I mentioned, this project is a continuation of k8s project. Therefore, you should consider using the existing VM from it or starting with an entirely new VM. However, I HIGHLY RECOMMEND the first option because we’ll need to deploy the database on Kubernetes after this.
- Secondly, let’s clarify everything once more. I’ll only focus on aspects related to the DB in this project. All <ins>*setup steps*</ins> and <ins>*VM scripts*</ins> must be within the [K8s](https://github.com/nnbaocuong99/k8s) project. Feel free to review it thoroughly to ensure 100% accuracy before you begin.
- What we need to do in setup steps (requirements)
  - *2 VMs for Master, Worker node.*
  - *K8s cluster.*
  - *CI/CD system already in operation. (skip this step if you followed since K8s).*

> [!caution]
> - *Please skip the entire setup steps if you’ve already succeeded with them in a previous Kubernetes project. The setup steps are intended for those who are starting a brand new project.*
> - *This is just a template, you need to modify these script ALL by yourself, even the DB config.*
> - *Highly recommend `Nodeport` in this case.*

<br>

### ✨ Install and work with Database <ins>on K8s</ins>
#### <ins>1:</ins>
- Install and setup ArgocD, create Namespace by follow [these steps](https://github.com/nnbaocuong99/k8s#2-1).
- Change it to `LoadBalancer`
  ```yaml
  $ kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
  ```

#### <ins>2:</ins>
- Skip this step if your CI/CD is still in operation or setup if you don’t have one. For more information, check [this](https://github.com/nnbaocuong99/k8s#2-ci).
- Login into ArgoCD, `Settings`/`Add Repository`. Add your repo and `helm` to update the config for it. Dont forget to create an application if you didn't
- Fill the form like the 1st picture and and you will see the exactly the same with the 2nd picture
  <div align="center">
      <img src="https://github.com/nnbaocuong99/Database/assets/100349044/2d716984-5e90-4d2c-b395-70749bcf406c" alt="uvu" width="900"> </br> <sup>Pic. 1</sup>
      <br>
      <br>
  </div>
  <div align="center">
      <img src="https://github.com/nnbaocuong99/Database/assets/100349044/490dd351-51e4-4ad7-a3b6-b92749f43cab" alt="uvu" width="900"> </br> <sup>Pic. 2</sup>
      <br>
      <br>
  </div>

#### <ins>3:</ins>
- In short, this step involves modifying your `.yaml` files in your repository by adding some configuration for your DB.
- If you’ve started a brand new project, you should check these `Helm packages` by Bitnami for [MariaDB](https://artifacthub.io/packages/helm/bitnami/mariadb) & [MongoDB](https://artifacthub.io/packages/helm/bitnami/mongodb) to get more information and read them in detail.
- Or update your `Chart.yaml` and `values.yaml` files by adding this and config them as yours
  - `Chart.yaml`
    ```yaml
    dependencies:
      - name: mariadb
        version: 11.0.11
        repository: https://charts.bitnami.com/bitnami
        condition: mariadb.enabled
      - name: mongodb
        version: 12.1.16
        repository: https://charts.bitnami.com/bitnami
        condition: mongodb.enabled
    ```
  - `values.yaml`
    ```yaml
    mongodb:
      enabled: true
      nameOverride: "mongodb"
      fullnameOverride: "mongodb"
      architecture: "standalone"
      auth:
        rootUser: "YOUR_ROOT_USER"
        rootPassword: "YOUR_ROOTPASSWORD"
      service:
        type: NodePort or PortForward
        nodePort: YOUR_PORT
      persistence:
        enabled: false
        #existingClaim:

    mariadb:
      enabled: true
        image:
        debug: true
      nameOverride: "mariadb"
      fullnameOverride: "mariadb"
      architecture: "standalone"
      auth:
        rootPassword: "YOUR_ROOT_PASSWORD"
        password: "YOUR_PASSWORD"
      primary:
        resources:
          requests:
          cpu: 
          memory: 
          limits:
          cpu:
          memory:
      service:
        type: NodePort or PortForward
        nodePort: YOUR_PORT
      persistence:
        enabled: false
        #existingClaim:
      volumePermissions:
        enabled: true
    ```
- `Commit` and refresh.

#### <ins>4:</ins>
- <ins>*THIS STEP IS OPTIONAL FOR ADVANCED USERS*</ins> // Once you have done all these steps upthere you'll see that you have Dbs in your k8s cluster. And to make sure about that we need tools to test the connection before you move the next step.
> [!note]
> #### Installation guide
> ###### MariaDB
> - You need to download **`mySQL`** to test your connection.
> - For installation check [this](https://github.com/nnbaocuong99/Database/tree/main/MariaDB)
> ###### MongoDB
> - With MongoDB we have so many different options, you can decide it.
> - For installation check [this](https://github.com/nnbaocuong99/Database/tree/main/MongoDB)


#### <ins>5: (Optional)</ins>
- You can import your real data, or even fake data. I'm gonna use [Mockaroo](https://www.mockaroo.com/) create some basic data.
- In case you using Mockaroo, fill it to generate your data then `Save as` `.CSV` or `.JSON`.

#### <ins>6:</ins>
- After the databases have been created, we need to create a database within them. YES! You’re not wrong if you’ve followed along until this step. In the previous step, we just applied to get a database on the cluster, but it’s empty.
- Explain a few small, simple steps I'll do next:
  - Exec into the Database via Rancher terminal.
  - Create Database, Table and insert Data
  - For more syntax, please visit [dev.mysql.com](https://dev.mysql.com/doc/refman/8.4/en/sql-statements.html) and [mongodb.com/docs](https://www.mongodb.com/docs/manual/reference/command/).

#### <ins>7:</ins>
##### MariaDB:
- Use [**Mysql Workbench**](https://dev.mysql.com/downloads/workbench/) to test the connection and work with it. If you're following my method fill it like in the form below. or nevgative to MariaDB using Rancher. Select `mariadb-node` and `execute shell` to start it

  <div align="center">
      <img src="https://github.com/nnbaocuong99/Database/assets/100349044/08f9cfb8-3c2f-4c6a-8d65-48d6523e658c" alt="uvu" width="900"> </br> <sup>Using Workbench</sup>
      <br>
      <br>
  </div>

  <div align="center">
      <img src="https://github.com/nnbaocuong99/Database/assets/100349044/25a1428a-d487-4a87-9cef-ed49a9596f04" alt="uvu" width="900"> </br> <sup>Using Rancher</sup>
      <br>
      <br>
  </div>

- Run this command with the following password in your `.yaml` file.
  ```nginx
  $ mysql -u root -p
  ```

- Create database by run the command below or use **`Mysql Workbench`**
  ```nginx
  # command
  $ create database example_name

  # result
  $ Query OK, 1 row affected (0.02 sec)
  ```
 
- Use these command below: (read the # each)
  ```nginx
  # Show all the database
  $ show databases;

  # Use the database you want
  $ use database_name;

  # Create a table (in this case, I've created a table with 5 columns and inserted values through each line).
  $ create table employee_list_2 (employee_id INT, firstname VARCHAR(16), lastname VARCHAR(16), jobtitle VARCHAR(16), salary VARCHAR(16));

  # Insert data into the table
  $ INSERT INTO employee_list_2 (employee_id, firstname, lastname, jobtitle, salary) VALUES ('1', 'Sigrid', 'Bowkett', 'Librarian', '51907');
  ``` 

- Dump / backup and restore with `--all` (for more dump and restore options, check [this](https://mariadb.com/kb/en/mariadb-dump/))
  ```nginx
  # Dump
  $ mysqldump -u admin -p test > backup.sql

  # Restore
  $ mysql -u admin -p test < backup.sql
  ```

  <div align="center">
      <img src="https://github.com/nnbaocuong99/Database/assets/100349044/0d25fc25-cad8-4b81-9e41-744105a59cb4" alt="uvu" width="1000">
      <br>
      <br>
  </div>

- Result:

  <div align="center">
      <img src="https://github.com/nnbaocuong99/Database/assets/100349044/94a7eb54-4469-40dc-bc69-51aaa2a6bbd8" alt="uvu" width="1000">
      <br>
      <br>
  </div>

##### MongoDB:
> [!caution]
> *(Coming soon) I'm currently working to fix this errors asap. Because of some errors, so I'm still trying. Thankss for your patience.*

---  

<br>

### ✨ Install and work with Database <ins>on VPS</ins>

#### <ins>1:</ins>

***MariaDB***

> [!Warning]
> - *During the installation, you will be prompted to set a `root password` for MariaDB. Enter a secure password and remember it, as you will need it later.*
> - *Based on your requirements, different versions could be chosen.*

- Update the package list for upgrades and new package installations:
  ```nginx
  $ sudo apt update
  ```
- Install MariaDB by running the following command:
  ```nginx
  $ sudo apt install mariadb-server
  ```
- After the installation is complete, MariaDB should be start automatically. However, you can verify its status:
  ```nginx
  $ sudo systemctl status mariadb
  ```
- Secure your MariaDB installation by running the following command:
  ```nginx
  $ sudo mysql_secure_installation
  ```
- Access:
  ```yaml
  $ sudo mysql -u root -p
  ```

<br>

#### <ins>2:</ins>

***MongoDB***

- Update the package list for upgrades and new package installations:
  ```nginx
  $ sudo apt update
  ```
- Install MongoDB:
  ```nginx
  $ sudo apt install mongodb
  ```
- *Optional* | MongoDB will start automatically. However, you can verify its status:
  ```nginx
  $ sudo systemctl status mongodb
  ```
- With default configuration, MongoDB listens on the localhost interface. To access it from external machines, you may need to modify the MongoDB configuration. 
  ```nginx
  $ sudo nano /etc/mongodb.conf
  ```
  > *Inside the configuration file, look for the bind_ip directive and change its value to the IP address you want MongoDB to listen on. If you want MongoDB to listen on all available IP addresses, set it to `0.0.0.0`*

- Save the changes and restart MongoDB to apply the configuration changes:
   ```nginx
   $ sudo systemctl restart mongodb
   ```

<br>

#### <ins>3:</ins>

##### MariaDB

- Create a `user` with FULL permission although maria request to create a password during the installations. Check [this](https://www.hostinger.com/tutorials/mysql/how-create-mysql-user-and-grant-permissions-command-line) and following exactly same steps.
- Start with this command. In this case I created an account and grant privileges for an account name `admin`
  ```mysql
  $ mysql -u admin -p
  ```
- Once you're logged in. Start with those command below to show databases and create one if you dont have 1.
  ```nginx
  $ show databases;
  $ create database example_name;
  ```
- To create table with the title of the columns and the quantity of them (how many, what kind of data,...etc). In this case my template just for and list with ID, first, last name, job and salary. For more about datatype for exmaple `varchar(16)` check [this](https://www.w3schools.com/mysql/mysql_datatypes.asp)
  ```nginx
  $ create table employee_list_2 (employee_id INT, firstname VARCHAR(16), lastname VARCHAR(16), jobtitle VARCHAR(16), salary VARCHAR(16));
  ```
- Imagine it might be a table with 5 columns like this and now you have to `insert` data into it thru each row. This command to insert data and values:

  <br>

  | ID | First Name | Last Name | Job title | Salary |
  |----|------------|-----------|-----------|--------|

  <br>

  ```nginx
  $ INSERT INTO employee_list_2 (employee_id, firstname, lastname, jobtitle, salary) VALUES ('1', 'Sigrid', 'Bowkett', 'Librarian', '51907');
  ```

- Once you're done. Roll back by type `exit`. With me im gonna create a backup folder name `backup` cd into it and run the backup commnad and cat these file to make sure that my data was succesfully dumped. 
  ```nginx
  $ mysqldump -u admin -p test > backup.sql
  ```

  <div align="center">
      <img src="https://github.com/nnbaocuong99/Database/assets/100349044/a7ed32fe-9496-4627-874f-7e9b23be0d78" alt="uvu" width="800">
      <br>
      <br>
  </div>

- And the you can get into your db and run the same command up there to drop your table. remove your data and start to practice the backup
  
  <div align="center">
      <img src="https://github.com/nnbaocuong99/Database/assets/100349044/9bf8e545-dcbc-4bfe-b382-c30a44c3ec64" alt="uvu" width="800">
      <br>
      <br>
  </div>
  
- Ok. Now you're done. Backup your data into your db again
  ```nginx
  $ mysql -u admin -p test < backup.sql
  ```
  <div align="center">
      <img src="https://github.com/nnbaocuong99/Database/assets/100349044/aadaee76-1248-4fdf-b993-da8baf4bd50c" alt="uvu" width="800">
      <br>
      <br>
  </div>  

##### MongoDB:
- After the installations, starting by run the command:
  ```nginx
  $ mongo
  ```
  
- Show the databases you're having // use or create a db if you havent created one
  ```nginx
  $ show dbs
  $ use db_name
  ```

  <div align="center">
      <img src="https://github.com/nnbaocuong99/Database/assets/100349044/c37f0024-8214-401b-9642-d193ca8ade31" alt="uvu" width="950"> </br> <sup>in this case im using "test_mongo"</sup>
      <br>
      <br>
  </div>  

- Insert data into it
  ```ruby
  $ db.items.insertOne({document})
  $ db.items.insertMany([{document 1}, {document 2}])
  ```

- In this case im gonna insert a name list have 3 people and ID, age with 2 methods *`insertOne` & `insertMany`*. Result will return as below
  <div align="center">
      <img src="https://github.com/nnbaocuong99/Database/assets/100349044/fece2e2d-f9d5-4df9-9bb5-3ebc917c6eee" alt="uvu" width="600">
      <br>
      <br>
  </div> 

- Dump and restore data *`--all`*
  ```nginx
  # Dump, backup
  $ mongodump -d test_mongo -o /backup

  # Restore
  $ mongorestore --db test_mongo /backup/test_mongo
  ```

  <div align="center">
      <img src="https://github.com/nnbaocuong99/Database/assets/100349044/7e591878-56cf-4edd-a6d4-6f99be044ee8" alt="uvu" width="900">
      <br>
      <br>
  </div>   



#### ✨Explain:
> - I created a directory, folder name `backup` by running `mkdir backup`
> - Then ran the dump command up there to backup data and it will automatically create a folder name `test_mongo` included 2 files: `items.bson` and
>  `items.metadata.json`
> - Type `mongo` again and drop the `table` in the `test_mongo` to remove the data
>   <div align="left">
>       <img src="https://github.com/nnbaocuong99/Database/assets/100349044/02ac1b52-a17d-445f-a985-3212c01ddfeb" alt="uvu" width="300">
>       <br>
>       <br>
>   </div> 
> - Then use the `backup command` to restore data into the `test_mongo` again. here is the results:
>   <div align="center">
>       <img src="https://github.com/nnbaocuong99/Database/assets/100349044/f1e3659f-cca2-491c-8ff5-3ce2bde9ddc6" alt="uvu" width="750">
>       <br>
>       <br>
>   </div>      
  

---

<br>

### ✨ Install Master-slave for MariaDB, Replicaset for MongoDB

<br>

***The set up for HA (High Availability) is a design plus its corresponding implementation organizations would undertake so as to ensure that they have some level of operational continuity over a specified period. HA is critical in the context of databases and IT systems since it allows organizations to run their operations continuously without having any downtime.***

<br>

***Key Components of HA:***

- **Redundancy**: Multiple instances of critical components are deployed to eliminate single points of failure.
- **Failover**: Automatic switching to a redundant or standby system upon the failure of the primary system.
- **Load Balancing**: Distribution of workloads across multiple computing resources to optimize resource use and minimize response time.
- **Data Replication**: Continuous copying of data from one database or server to another to ensure data consistency across systems.
- **Monitoring and Alerting**: Continuous monitoring of system health and performance, with alerts for potential issues.

<br>

***Benefits of HA:***

- **Minimized Downtime**: Ensures continuous operation even in the maintenance.
- **Improved Reliability**: Reduces the risk of data loss and service interruptions.
- **Better Performance**: Load balancing can improve overall system performance.
- **Scalability**: Easier to scale resources.

<br>

> [!warning]
> - My configuration is stored at [HA-Setup](https://github.com/nnbaocuong99/Database/tree/main/HA-Setup)
> - *This is optional in this project!*
> - *Configuring can be considered intermediate to advanced skills*
> - *You can create a consistent backup of the master database using your preferred method (e.g., mysqldump, XtraBackup) and transfer the backup file to the slave server.*

<br>

#### <ins>MariaDB:</ins>
- run this command:
  ```nginx
  $ sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf
  ```

- Copy the config below or in `mariadb.cnf` in the master folder // Find and modify the following lines:
  ```mysql
  [mysqld]
  server-id = 1          # Unique ID for the master
  log-bin = /var/log/mysql/mysql-bin.log
  binlog_do_db = your_database_name
  ```
  
- Restart to apply the config
  ```nginx
  $ sudo systemctl restart mariadb
  ```

- Setup the master node
  ```nginx
  # Login
  $ sudo mysql -u root -p

  # Create replication user
  $ CREATE USER 'replication_user'@'%' IDENTIFIED BY 'password';
  $ GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'%';
  $ FLUSH PRIVILEGES;
  $ EXIT;
  ```

- Copy the config below or in `mariadb.cnf` in the slave folder // Find and modify the following lines:
  ```mysql
  [mysqld]
  server-id = 2          # Unique ID for the slave
  ```

- Setup the slave node
  ```nginx
  # Login
  $ sudo mysql -u root -p

  # Setup command
  CHANGE MASTER TO MASTER_HOST='master_ip_address',
  MASTER_USER='replication_user',
  MASTER_PASSWORD='password',
  MASTER_LOG_FILE='binlog_file_from_master',
  MASTER_LOG_POS=binlog_position_from_master;
  ```

- Run the slave, and check the status
  ```nginx
  START SLAVE;
  SHOW SLAVE STATUS \G;
  ```

- Look for and your're all done
  ```yaml
  Slave_IO_Running: Yes
  Slave_SQL_Running: Yes
  ```
  <div align="center">
      <img src="https://github.com/user-attachments/assets/3eaae724-2fd9-4b59-9b2a-004cbdf3139f" alt="uvu" width="500">
      <br>
      <br>
  </div> 

<br>

#### <ins>MongoDB:</ins>
- Access the config file
  ```nginx
  $ nano /etc/mongod.conf
  ```

- Copy the config below or in `mongod.cnf` copy the config.
  ```yaml
  replication:
  replSetName: "rs0"
  ```
  
  <div align="center">
      <img src="https://github.com/user-attachments/assets/f38b4527-5477-432b-bf4c-5cec7b111ebe" alt="uvu" width="700">
      <br>
      <br>
  </div> 

- Restart to apply the config
  ```nginx
  $ systemctl restart mongod
  ```

- Log in to the primary node
  ```sh
  $ mongo
  $ rs.initiate()
  ```

- Add replica-set
  ```ruby
  $ rs.add(“mongo-db2:27017”)
  $ rs.add(“mongo-db3:27017”)
  ```

> [!tip]
> - *Replace `"server1"`, `"server2"`, and `"server3"` with your actual server hostnames or IP addresses.*
> - *In this case, mine was `db1`, `db2`,...*
>   ```yaml
>   rs.initiate({
>     _id: "rs0",
>     members: [
>       { _id: 0, host: "server1:27017" },
>       { _id: 1, host: "server2:27017" },
>       { _id: 2, host: "server3:27017" }
>     ]
>   })
>   ```

- **OPTIONAL** To make sure a specific member-node becomes the primary:
  ```nginx
  cfg = rs.conf()
  cfg.members[0].priority = 2
  rs.reconfig(cfg)
  ```

- Once you add the nodes, you will see the output as `{‘ok’:1}`, which indicates a successful addition of nodes in the replica set. Check it by running
  ```sh
  $ rs.status()
  ```

- If your output look ike this, congrats!
  ```yaml
  { 
  "set" : "myitsocial", 
  "date" : ISODate("2022-02-10T06:15:02Z"), 
  "myState" : 1, 
  "members" : [ 
     { 
        "_id" : 0, 
        "name" : "192.168.56.200:27017", 
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
        "name" : "192.168.56.201:27017", 
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
        "name" : "192.168.56.202:27017", 
        "health" : 1, "state" : 2, 
        "stateStr" : "SECONDARY", 
        "uptime" : 302985, 
        "optime" : Timestamp(1644516902, 1), 
        "optimeDate" : ISODate("2022-02-10T06:15:02Z"), 
        "lastHeartbeat" : ISODate("2022-02-10T06:15:02Z"), 
        "lastHeartbeatRecv" : ISODate("2022-02-10T06:15:02Z"), 
        "pingMs" : 0, 
        "syncingTo" : "192.168.56.200:27017" 
     } 
  ], 
  "ok" : 1 
  } 
  ```
---

<br>

<p align='center'> Congrats! you're doing great. Thanks for reading until this and good luck with your journey. </br> ✨ Best wishes, 𝓃𝓃𝒷𝒸, </p>	















<!--

  
  #dump / backup
  ```ruby
  mongodump -h sample.mongodbhost.com:27017 -d DATABASE_NAME -u USER_NAME -p SAMPLE_PASSWORD -o ~/Desktop
  ``` 

  #restore
  ```ruby
  mongorestore --host sample.mongohost.com --port 27017 --username USER_NAME --password SAMPLE_PASSWORD --db DATABASE_NAME .
  ```








### To create a database on Kubernetes using Helm and Argo CD, you can follow these steps:

1. Install Helm and Argo CD on your Kubernetes cluster.

2. Create a Helm chart for your database application. The chart should contain the necessary resources (e.g. Deployment, Service, ConfigMap) to deploy and configure the database. You can use the helm create command to generate a basic chart structure, and then modify it to fit your specific needs.

3. Create a Git repository to store your Helm chart. Push the chart files to the repository.

4. Configure Argo CD to monitor the Git repository and deploy the chart to your Kubernetes cluster. You can do this by creating an Application resource in Argo CD and specifying the Git repository, chart path, and deployment target (e.g. the Kubernetes namespace).

5. When you want to deploy the database, you can simply update the Helm chart in the Git repository, and Argo CD will automatically detect the changes and apply them to the cluster.
```yaml
my-database/
  Chart.yaml
  values.yaml
  templates/
    deployment.yaml
    service.yaml
    configmap.yaml
```
And here's an example of what the Argo CD Application resource might look like:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-database
spec:
  destination:
    namespace: my-namespace
    server: https://kubernetes.default.svc
  source:
    path: my-database
    repoURL: https://github.com/my-org/my-repo.git
    targetRevision: HEAD
  project: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```
Note that the exact configuration will depend on your specific database application and deployment requirements.

---

### Step 1:
Ensure that you have a running Kubernetes cluster and have ArgoCD installed and configured to manage your applications.


### Step 2:
Install the ArgoCD CLI tool on your local machine if you haven't done so already. You can find the instructions for installing the CLI tool in the ArgoCD documentation.


### Step 3:
Create a new application in ArgoCD by running the following command in your terminal:
```bash
argocd app create <app-name> \
--repo <git-repo-url> \
--path <path-to-helm-chart> \
--dest-server <kubernetes-cluster-url> \
--dest-namespace <namespace> \
--helm-set <set-options>
```
Replace the placeholders with the appropriate values. This command creates a new application in ArgoCD, and instructs it to deploy the Helm chart located in `<git-repo-url>` at `<path-to-helm-chart>` to `<kubernetes-cluster-url>` in the `<namespace>` namespace. You can also specify additional Helm chart options using the `--helm-set` flag.


### Step 4:
Once you have created the application, you can synchronize it with the Git repository by running:
```
argocd app sync <app-name>
```
This command will retrieve the latest version of the Helm chart from the Git repository and deploy it to the Kubernetes cluster.


### Step 5:
Monitor the deployment by checking the status of the application in the ArgoCD UI or by running:
```
argocd app get <app-name>
```
This command will display the current status of the application deployment.
-->


