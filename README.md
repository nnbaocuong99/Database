## (WIP) How to install DB helm chart using ArgoCD

> - [Project](https://github.com/users/nnbaocuong99/projects/2)
> - [Issues](https://github.com/nnbaocuong99/Database/issues)

Step by Step how to install


<!--

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
