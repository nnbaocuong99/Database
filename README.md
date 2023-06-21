# How to create MongoDB & Maria DB with `Helm chart` and `ArgoCD`

<br>

## ❗️ Introducing

### ***Sumary:***
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

###  ***Todo list / Workflow to follow (update weekly):***
- Setup VM:
  - [x] Create `master`
  - [X] Create `worker` node

- Create k8s cluster:
  - [x] Create k8s cluster ([guides here](https://github.com/nnbaocuong99/k8s#--install-rancher--setup-k8s-cluster))
  - [x] Install kubectl and helm.

- Setup ArgoCD:
  - [ ] Change type to `Load Balancer`
  - [ ] Change the `port-forward` svc to `node-port`

- ~~Setup CI:~~
  - ~~[ ] Add `Variables`~~
  - ~~[ ] Register `GitLab Runner`~~

- Setup CD:
  - [ ] Connect repo (Recommend Gitlab)
  - [ ] Create `Chart.yaml` and `values.yaml` / Update the configurations
    - [ ] Old project: Find a way to update `.yaml` file for ArgoCD to read and create the DB
    - [ ] New project: Create a new chart file with the default config of the `MongoDb` and `MaridaDB`

- Create Database:
  - [ ] `Add dependencies`
  - [ ] Config the `values.yaml`
  - [ ] Deploy, connect into it.

- Pratices / Dump data
  - [ ] Import data into Database using [Mockaroo](https://www.mockaroo.com/)
  - [ ] `backup` and `restore` ([command from official website]())

- *Still updating*

<br>

## ❗️ Lets working on it

### Part 1: Create VM, Install Docker and create k8s cluster

#### 1. Setup VM
- Based on my old project In this repo [How to install k8s and CI/CD](https://github.com/nnbaocuong99/k8s) we gonna use the same script to create 2 VM `master` and `worker` node
- [this](https://github.com/nnbaocuong99/Database/blob/main/VM%20Scripts/README.md)

#### 2. Install Rancher and create k8s cluster
- Follow [these steps](https://github.com/nnbaocuong99/k8s#-setup)













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
