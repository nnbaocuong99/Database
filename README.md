# How to create MongoDB & Maria DB with `Helm chart` and `ArgoCD`

<br>

## ❗️ Introducing

### ***1. Sumary:***
- **About**
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
- Setup VM:
  - [x] Create `master`
  - [X] Create `worker` node

- Create k8s cluster:
  - [x] Create k8s cluster ([guides here](https://github.com/nnbaocuong99/k8s#--install-rancher--setup-k8s-cluster))
  - [x] Install kubectl and helm.

- Setup ArgoCD:
  - [x] Change type to `Load Balancer`
  - [x] Change the `port-forward` svc to ~~`node-port`~~ (connect using `wokernode-port`)

- ~~Setup CI:~~
  - [ ] ~~Add `Variables`~~
  - [ ] ~~Register `GitLab Runner`~~

- Setup CD:
  - [x] Connect repo (Recommend Gitlab)
  - [x] Create `Chart.yaml` and `values.yaml` / Update the configurations
    - [x] Old project: Find a way to update `.yaml` file for ArgoCD to read and create the DB
    - [x] New project: Create a new chart file with the default config of the `MongoDb` and `MaridaDB`

- Create Database both `MongoDb` and `MariaDB`:
  - [x] `Add dependencies`
  - [x] Config the `values.yaml`
  - [x] Apply and deploy the Databases on k8s
 

- Pratices / Dump data
  - [x] Download tool, test connection.
  - [x] Create Database. table.
  - [x] Genarate data.
  - [x] Insert / Import data into Database.
  - [ ] Practice: `backup`, `drop` table and then `restore.

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

<br>

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

  ![image](https://github.com/nnbaocuong99/Database/assets/100349044/0d25fc25-cad8-4b81-9e41-744105a59cb4)

  - You can create database by run the following commnad below or use **`Mysql Workbench`**
  ```ruby
  create database example_name
  ```
  > the result gonna be: **`Query OK, 1 row affected (0.02 sec)`**

  - Use it:
  ```bash
  #show all the database in it
  show databases;

  #use the database you want
  use database_name;
  ``` 

  </details>

- MongoDB:
  <details>

  content

  </details>
































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
