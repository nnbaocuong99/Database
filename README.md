## How to install DB helm chart using ArgoCD

> [Project](https://github.com/users/nnbaocuong99/projects/2)

---

### Step 1:
Ensure that you have a running Kubernetes cluster and have ArgoCD installed and configured to manage your applications.


### Step 2:
Install the ArgoCD CLI tool on your local machine if you haven't done so already. You can find the instructions for installing the CLI tool in the ArgoCD documentation.


### Step 3:
Create a new application in ArgoCD by running the following command in your terminal:
```
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
