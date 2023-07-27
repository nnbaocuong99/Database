# How to create MongoDB & Maria DB with `Helm chart` and `ArgoCD`

<br>

## ❗️ Introducing

### ***1. Sumary:***
- **About the project:**
  - **Main topic:** This project will show how to *create, deploy, backup and restore data* on Database (MongoDb and MariaDB in this case) this is not the end and I'm still working on it. This is also my report and 100% on-prem.
  - VM script by [@TruongLM](https://github.com/lmt2407)
  - For more infor (`script`, `how to setup`, `run` and `work` with k8s, `tags`,...) check [this repo](https://github.com/nnbaocuong99/k8s)

- **Tools:**
  <details>

   - [Kubernetes](https://kubernetes.io)
   - [Rancher](https://rancher.com/docs/)
   - [Apache](https://maven.apache.org)
   - [Docker](https://www.docker.com)
   - [Helm](https://helm.sh)
   - [ArgoCD](https://argo-cd.readthedocs.io/en/stable/)
   - [Vmbox](https://www.virtualbox.org)

  </details>

- **Project / Roadmap:**
  <details>

   - [Roadmap](https://github.com/nnbaocuong99/Database/projects)
   - [Project](https://github.com/users/nnbaocuong99/projects/2)
   - [Issues](https://github.com/nnbaocuong99/Database/issues)
     
  </details>

<br>

###  ***2. Todo list / Workflow to follow (update weekly):***
- [x] Setup VM:
- [x] Create k8s cluster:
- [x] Setup ArgoCD:
- [x] Setup CD:
- [x] Deloy Database on k8s:
  - [ ] ~~Mongodb~~
  - [x] Mariadb
- [x] Pratices / Dump data
- [x] Deploy Database on VPS:
  - [x] Mongodb
  - [x] Mariadb
- [ ] Covert, install Replicaset, Masterslave

<br>

## ❗️ Lets get into it

### ✏️Part 1: Create VM, Install Docker and create k8s cluster

#### 1. Setup VM
- Based on my old project In this repo [How to install k8s and CI/CD](https://github.com/nnbaocuong99/k8s) we gonna use the same script to create 2 VM `master` and `worker` node
- [this](https://github.com/nnbaocuong99/Database/blob/main/VM%20Scripts/README.md)

#### 2. Install Rancher and create k8s cluster
- Follow [these steps](https://github.com/nnbaocuong99/k8s#-setup)

<br>

### ✏️Part 2: Setup ArgoCD / CI/CD / Create Database
#### 1. Setup ArgoCD
- Follow [these steps](https://github.com/nnbaocuong99/k8s#-setup-argocd-) to setup ArgoCD / if your're started a brand new project check my [old project](https://github.com/nnbaocuong99/k8s)
- Change it to `LoadBalancer`
```ruby
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

#### 2. Setup CI/CD:
- Setup `CI` check [this](https://github.com/nnbaocuong99/k8s#-ci)
- Setup `CD`
  - Get into your ArgoCD, `Settings` -> `Add Repository` and add your repo and `helm` repo to update the config for helm
  - Fill them form like the 1st picture and and you will see the exactly the same with the 2nd picture
    > Repo link to copy: `https://charts.bitnami.com/bitnami`
    <img src="https://github.com/nnbaocuong99/Database/assets/100349044/2d716984-5e90-4d2c-b395-70749bcf406c" alt="uvu" width="800">
    <img src="https://github.com/nnbaocuong99/Database/assets/100349044/490dd351-51e4-4ad7-a3b6-b92749f43cab" alt="uvu" width="800">
- Create an application if you didn't. for more check [this](https://github.com/nnbaocuong99/k8s#%EF%B8%8F-step-7)

#### 3. Create Database
- Update the `Chart.yaml` and `values.yaml` 
  - If you're started a brand new project check these: [MariaDB](https://artifacthub.io/packages/helm/bitnami/mariadb) and [MongoDB](https://artifacthub.io/packages/helm/bitnami/mongodb) chart
  - If you're following the way to update from the old one, copy 2 `.yaml` file below 

- my raw `Chart.yaml` config file to copy

  <details>

  ```yaml
  apiVersion: v2
  name: demo-app
  description: A Helm chart for Kubernetes

  # A chart can be either an 'application' or a 'library' chart.
  #
  # Application charts are a collection of templates that can be packaged into versioned archives
  # to be deployed.
  #
  # Library charts provide useful utilities or functions for the chart developer. They're included as
  # a dependency of application charts to inject those utilities and functions into the rendering
  # pipeline. Library charts do not define any templates and therefore cannot be deployed.
  type: application

  # This is the chart version. This version number should be incremented each time you make changes
  # to the chart and its templates, including the app version.
  # Versions are expected to follow Semantic Versioning (https://semver.org/)
  version: 0.1.0

  # This is the version number of the application being deployed. This version number should be
  # incremented each time you make changes to the application. Versions are not expected to
  # follow Semantic Versioning. They should reflect the version the application is using.
  # It is recommended to use it with quotes.
  appVersion: "1.16.0"

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

  </details>

- my raw `values.yaml` config file to copy

  <details>

  ```yaml
  # Default values for demo-app.
  # This is a YAML-formatted file.
  # Declare variables to be passed into your templates.

  replicaCount: 1

  image:
    repository: nnbaocuong99/demo-gitlabci
    pullPolicy: Always
    # Overrides the image tag whose default is the chart appVersion.
    tag: "1.0"

  imagePullSecrets: []
  nameOverride: ""
  fullnameOverride: ""

  serviceAccount:
    # Specifies whether a service account should be created
    create: true
    # Annotations to add to the service account
    annotations: {}
    # The name of the service account to use.
    # If not set and create is true, a name is generated using the fullname template
    name: ""

  podAnnotations: {}

  podSecurityContext: {}
    # fsGroup: 2000

  securityContext: {}
    # capabilities:
    #   drop:
    #   - ALL
    # readOnlyRootFilesystem: true
    # runAsNonRoot: true
    # runAsUser: 1000

  service:
    type: NodePort
    port: 80

  ingress:
    enabled: false
    className: ""
    annotations: {}
      # kubernetes.io/ingress.class: nginx
      # kubernetes.io/tls-acme: "true"
    hosts:
      - host: chart-example.local
        paths:
          - path: /
            pathType: ImplementationSpecific
    tls: []
    #  - secretName: chart-example-tls
    #    hosts:
    #      - chart-example.local

  resources:
    # We usually recommend not to specify default resources and to leave this as a conscious
    # choice for the user. This also increases chances charts run on environments with little
    # resources, such as Minikube. If you do want to specify resources, uncomment the following
    # lines, adjust them as necessary, and remove the curly braces after 'resources:'.
    limits:
      cpu: 100m
      memory: 128Mi
    requests:
      cpu: 100m
      memory: 128Mi

  autoscaling:
    enabled: false
    minReplicas: 1
    maxReplicas: 100
    targetCPUUtilizationPercentage: 80
    # targetMemoryUtilizationPercentage: 80

  nodeSelector: {}

  tolerations: []

  affinity: {}

  mongodb:
    enabled: true
    nameOverride: "mongodb"
    fullnameOverride: "mongodb"
    architecture: "standalone"
    auth:
      rootUser: "admin"
      rootPassword: "erdG8qxerVfMPxTd8VHs"
    service:
      type: NodePort
      nodePort: 32368
    persistence:
      enabled: false
      #existingClaim: "pvc-my-nextpay-tech-mongodb"

  mariadb:
    enabled: true
      image:
      debug: true
    nameOverride: "mariadb"
    fullnameOverride: "mariadb"
    architecture: "standalone"
     auth:
      rootPassword: "44Xb7YDFgKHgp7kYLXzb"
      password: "rL43Ydk8DmYUKYmurML3"
    primary:
      resources:
        # requests:
        #   cpu: "1000m"
        #   memory: "1536Mi"
        # limits:
        #   cpu: "1000m"
        #   memory: "1536Mi"
      service:
        type: NodePort
        nodePort: 32268
      persistence:
        enabled: false
        #existingClaim: "pvc-my-nextpay-tech-mariadb"
    volumePermissions:
      enabled: true
  ```

  </details>

- `Commit` and refresh and your will have a Database in your k8s cluster

<br>

### ✏️Part 3: Work with Db, practices
#### 1. Download tools
- Okay, so once you have done all these steps upthere, now you'll have a Database in your k8s cluster. To make sure about that we need to download tools to test the connection and you can move to the next step
- With:
  - MariaDB: You need to download **`mySQL`** to test your connection. and **`mySQLdump`** to dump and restore your data. For installation check [my guides](https://github.com/nnbaocuong99/Database/tree/main/MariaDB)
  - MongoDB: About the test connection there are so many options so you can decide it, `dump` and `restore` You need to download MongoDatabaseTools. For installation check [my guides](https://github.com/nnbaocuong99/Database/tree/main/MongoDB)

#### 2. Generate data `exec` into, create database and table
- There are tons of websites where we can create fake data to insert, import into our Databases. In this case, I'm gonna use [Mockaroo](https://www.mockaroo.com/).
- Just fill it to generate your data then `Save as` `.CSV` or `.JSON`. Check to make sure that file have datas.

#### 3. Work
- After the Databases has been created. Now we need to create a Database in that, because in the previous step we just apply to got a Database on the cluster, its empty in there. Here is a few small simple steps you should follow in this step:
  - Step 1: Exec into the Database note via Rancher
  - Step 2: Create Database
  - Step 3: Create Table, insert Data

- MariaDB:
  <details>
  
  - You can use **`Mysql Workbench`** to test the connection and work with it (Create DB, table,...), if you're following my method fill it like in the form below:

  ![image](https://github.com/nnbaocuong99/Database/assets/100349044/08f9cfb8-3c2f-4c6a-8d65-48d6523e658c)

  - or nevgative to MariaDB using Rancher. Select `mariadb-node` and `execute shell` to start it
   
    
  ![image](https://github.com/nnbaocuong99/Database/assets/100349044/25a1428a-d487-4a87-9cef-ed49a9596f04)


  - Once we get into it. run this command with user: **`root`** and the following password in your `.yaml` file, in this case `root-password` in my `.yaml` is: `44Xb7YDFgKHgp7kYLXzb` (it will ask for password after you run the command)
  ```mysql
  mysql -u root -p
  ```

  - You can create database by run the following commnad below or use **`Mysql Workbench`**
  ```ruby
  create database example_name
  ```
  > the result gonna be: **`Query OK, 1 row affected (0.02 sec)`**

  - Use these command below to use and work with the database u just created:
  ```bash
  #show all the database in it
  show databases;

  #use the database you want
  use database_name;

  #create a table (in this case, I've created a table with 5 columns and inserted values through each line).
  create table employee_list_2 (employee_id INT, firstname VARCHAR(16), lastname VARCHAR(16), jobtitle VARCHAR(16), salary VARCHAR(16));

  #insert data into the table
  INSERT INTO employee_list_2 (employee_id, firstname, lastname, jobtitle, salary) VALUES ('1', 'Sigrid', 'Bowkett', 'Librarian', '51907');
  ``` 

  - Move on the next step. Dump / backup and restore data into the db (the commands i've been using)
  ```mysql
  #dump
  mysqldump -u admin -p test > backup.sql

  #restore
  mysql -u admin -p test < backup.sql
  ```

  ![image](https://github.com/nnbaocuong99/Database/assets/100349044/0d25fc25-cad8-4b81-9e41-744105a59cb4)

  - Result:
    
  ![image](https://github.com/nnbaocuong99/Database/assets/100349044/94a7eb54-4469-40dc-bc69-51aaa2a6bbd8)


  </details>

- MongoDB:
  <details>

  (Coming soon) I'm currently working to fix this errors asap. Because of some errors, so I'm still trying. Thankss for your patience.
  
  </details>

<br>

### ✏️Part 4: Install Databases on VPS

#### 1.Prepare a VM <sup>In this case im gonna use the same script but with the `focal 20.04` version</sup>
###### Scripts

<details>

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"

  config.vm.define "master" do |master|
    config.vm.network "private_network", ip: "192.168.56.203"
    master.vm.hostname = "db-vps-20.04"
    master.vm.provider "virtualbox" do |vb|
        vb.name = "db-vps-20.04"
        vb.memory = 3096
        vb.cpus = 3
    end
  end

  # Chạy các lệnh shell
  config.vm.provision "shell", inline: <<-SHELL
    # Đặt pass 123 có tài khoản root và cho phép SSH
    useradd cuongnnb
    usermod -aG sudo cuongnnb
    #usermod -aG docker cuongnnb
    echo "cuongnnb:123" | sudo chpasswd
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    systemctl reload sshd
    # Ghi nội dung sau ra file /etc/hosts để truy cập được các máy theo HOSTNAME
    echo "192.168.56.200 master-ubuntu-20.04" >> /etc/hosts
    echo "192.168.56.201 worker-node1-ubuntu-20.04" >> /etc/hosts

    #cài đặt docker và kubernetes
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt install docker.io -y
    usermod -aG docker cuongnnb
  SHELL
end
```

</details>

#### 2. Install MongoDB, MariaDB

- MongoDB:

  I ran the following command, and MariaDB was successfully installed.
  - Update the package list for upgrades and new package installations:
  ```ruby
  sudo apt update
  ```
  - Install MongoDB:
  ```ruby
  sudo apt install mongodb
  ```
  - *Optional* | MongoDB will start automatically. However, you can verify its status:
  ```ruby
  sudo systemctl status mongodb
  ```
  - With default configuration, MongoDB listens on the localhost interface. To access it from external machines, you may need to modify the MongoDB configuration. 
  ```ruby
  sudo nano /etc/mongodb.conf
  ```
  > Inside the configuration file, look for the bind_ip directive and change its value to the IP address you want MongoDB to listen on. If you want MongoDB to listen on all available IP addresses, set it to `0.0.0.0`

  - Save the changes and restart MongoDB to apply the configuration changes:
   ```ruby
   sudo systemctl restart mongodb
   ```


- MariaDB:

  Same things with Mongo, MariaDB was successfully installed. Here are the commands:

  - Update the package list for upgrades and new package installations:
  ```ruby
  sudo apt update
  ```

  - Install MariaDB by running the following command:
  ```ruby
  sudo apt install mariadb-server
  ```

  > **Warning** During the installation, you will be prompted to set a root password for MariaDB. Enter a secure password and remember it, as you will need it later.

  - After the installation is complete, MariaDB should be start automatically. However, you can verify its status:
  ```ruby
  sudo systemctl status mariadb
  ```

  - Secure your MariaDB installation by running the following command:
  ```ruby
  sudo mysql_secure_installation
  ```

  > This command will guide you through a series of prompts to configure some security settings. It's recommended to answer "Y" to all the prompts, including removing anonymous users, disallowing remote root login, removing test databases, and reloading privilege tables.

  - Access:
  ```ruby
  sudo mysql -u root -p
  ```

#### 3. Work with MongoDB, MariaDB

- MongoDB

  <details>

  - After the installations, starting by run the command:
  ```
  mongo
  ```
  
  - Run the commands to show the databases you're having
  ```
  show dbs
  ```
  
  - Run the command to use or create a db if you havent created one
  ```
  use db_name | in this case im using "use test_mongo"
  ```
  
    ![image](https://github.com/nnbaocuong99/Database/assets/100349044/c37f0024-8214-401b-9642-d193ca8ade31)  

  - Insert data into it by runny the follwing syntax
  ```
  db.items.insertOne({document})
  db.items.insertMany([{document 1}, {document 2}])
  ```

  - In this case im gonna insert a name list have 3 people and ID, age with 2 methods `insertOne` & `insertMany`
  - Result will be:

    ![image](https://github.com/nnbaocuong99/Database/assets/100349044/fece2e2d-f9d5-4df9-9bb5-3ebc917c6eee)

  - Dump and restore data
    - Here are the dump and restore command and the result:
    ```
    #dump, backup
    mongodump -d test_mongo -o /backup

    #restore
    mongorestore --db test_mongo /backup/test_mongo
    ```
    
    ![image](https://github.com/nnbaocuong99/Database/assets/100349044/7e591878-56cf-4edd-a6d4-6f99be044ee8)
 
  - Explain:
    - I created a directory, folder name `backup` by running `mkdir backup`
    - Then I ran the dump command up there to backup data and it will automatically create a folder name `test_mongo` included 2 files: `items.bson` and `items.metadata.json`
    - Type `mongo` again and drop the `table` in the `test_mongo` to remove the data
      
    ![image](https://github.com/nnbaocuong99/Database/assets/100349044/02ac1b52-a17d-445f-a985-3212c01ddfeb)

    - Then use the backup command to restore data into the `test_mongo` again. here is the results:
      
    ![image](https://github.com/nnbaocuong99/Database/assets/100349044/f1e3659f-cca2-491c-8ff5-3ce2bde9ddc6)

  </details>

- MariaDB

  <details>
  
  - First you need to create one user with full permission although maria request to create a password during the installations. Check [this](https://www.hostinger.com/tutorials/mysql/how-create-mysql-user-and-grant-permissions-command-line) and following exactly same steps.
  - Then start with this command. In this case I created an account and grant privileges for an account name `admin`
  ```mysql
  mysql -u admin -p
  ```
  - Once you're logged in. Start with those command below to show databases
  ```mysql
  show databases;
  ```

  - To create your own databases (if you dont have 1)
  ```mysql
  create database example_name;
  ```

  - to create table with the title of the columns and the quantity of them (how many, what kind of data,...etc). In this case my template just for and list with ID, first, last name, job and salary. For more about datatype for exmaple `varchar(16)` check [this](https://www.w3schools.com/mysql/mysql_datatypes.asp)
  ```
  create table employee_list_2 (employee_id INT, firstname VARCHAR(16), lastname VARCHAR(16), jobtitle VARCHAR(16), salary VARCHAR(16));
  ```
  - Once your got this. Imagine it might be a table with 5 columns like this and now you have to `insert` data into it thru each row
  
  | ID | First Name | Last Name | Job title | Salary |
  |----|------------|-----------|-----------|--------|

  - Following these steps. im using this command to insert data and values:
  ```
  NSERT INTO employee_list_2 (employee_id, firstname, lastname, jobtitle, salary) VALUES ('1', 'Sigrid', 'Bowkett', 'Librarian', '51907');
  ```

  - Once you're done. Roll back by type `exit`. With me im gonna create a backup folder name `backup` cd into it and run the backup commnad and cat these file to make sure that my data was succesfully dumped. 
  ```
  mysqldump -u admin -p test > backup.sql
  ```

  ![image](https://github.com/nnbaocuong99/Database/assets/100349044/a7ed32fe-9496-4627-874f-7e9b23be0d78)

  - And the you can get into your db and run the same command up there to drop your table. remove your data and start to practice the backup
  
  ![image](https://github.com/nnbaocuong99/Database/assets/100349044/9bf8e545-dcbc-4bfe-b382-c30a44c3ec64)

  - Ok. Now you're done. run this command to backup your data into your db again
  ```
  mysql -u admin -p test < backup.sql
  ```
  
  ![image](https://github.com/nnbaocuong99/Database/assets/100349044/aadaee76-1248-4fdf-b993-da8baf4bd50c)

  </details>

<br>

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
