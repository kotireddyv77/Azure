# Kubernetes  - PODs

## Step-01: PODs Introduction
- What is a POD ?

## Step-02: PODs Demo
### Get Worker Nodes Status
- Verify if kubernetes worker nodes are ready.

# Configure Cluster Creds (kube config) for Azure AKS Clusters
az aks get-credentials --resource-group aks-rg1 --name aksdemo1


# Get Worker Node Status
kubectl get nodes


# Get Worker Node Status with wide option
kubectl get nodes -o wide


### Create a Pod
- Create a Pod

# Replace Pod Name, Container Image
kubectl run my-first-pod --image atingupta2005/kubenginx:1.0.0


### List Pods
- Get the list of pods

# List Pods
kubectl get pods


# Alias name for pods is po
kubectl get po


### List Pods with wide option
- List pods with wide option which also provide Node information on which Pod is running

kubectl get pods -o wide


### What happened in the background when above command is run?
1. Kubernetes created a pod
2. Pulled the docker image from docker hub
3. Created the container in the pod
4. Started the container present in the pod


### Describe Pod
- Describe the POD, primarily required during troubleshooting.
- Events shown will be of a great help during troubleshooting.

# To get list of pod names
kubectl get pods


# Describe the Pod
kubectl describe pod my-first-pod


### Access Application
- Currently we can access this application only inside worker nodes
- To access it externally, we need to create a **Load Balancer Service**
- **Services** is one very important concept in Kubernetes

### Delete Pod

# To get list of pod names
kubectl get pods


# Delete Pod
kubectl delete pod my-first-pod


## Step-03: Load Balancer Service Introduction
- What are Services in k8s?
- What is a Load Balancer Service?
- How it works?

## Step-04: Demo - Expose Pod with a Service
- Expose pod with a service (Load Balancer Service) to access the application externally (from internet)
- Verify the following before LB Service creation
  - Azure Standard Load Balancer created for Azure AKS Cluster
    - Frontend IP Configuration
    - Load Balancing Rules
  - Azure Public IP

# Create  a Pod
kubectl run my-first-pod --image atingupta2005/kubenginx:1.0.0


# Expose Pod as a Service
kubectl expose pod my-first-pod  --type=LoadBalancer --port=80 --name=my-first-service


# Get Service Info
kubectl get svc


# Describe Service
kubectl describe service my-first-service


# Access Application
curl http://<External-IP-from-get-service-output>

- Verify the following after LB Service creation
  - Azure Standard Load Balancer created for Azure AKS Cluster
    - Frontend IP Configuration
    - Load Balancing Rules
  - Azure Public IP
- View the resources in Azure AKS Cluster - Resources section from Azure Portal Management Console  

## Step-05: Interact with a Pod

### Verify Pod Logs

# Get Pod Name
kubectl get po


# Dump Pod logs
kubectl logs my-first-pod


# Stream pod logs with -f option and access application to see logs
kubectl logs -f my-first-pod

### Connect to Container in a POD
- **Connect to a Container in POD and execute commands**

# Connect to Nginx Container in a POD
kubectl exec -it my-first-pod -- /bin/bash


# Execute some commands in Nginx container
ls
cd /usr/share/nginx/html
cat index.html
exit


- **Running individual commands in a Container**

# Sample Commands
kubectl exec -it my-first-pod -- env


kubectl exec -it my-first-pod -- ls


kubectl exec -it my-first-pod -- cat /usr/share/nginx/html/index.html

## Step-06: Get YAML Output of Pod & Service
### Get YAML Output

# Get pod definition YAML output
kubectl get pod my-first-pod -o yaml   


# Get service definition YAML output
kubectl get service my-first-service -o yaml   


## Step-07: Clean-Up

# Get all Objects in default namespace
kubectl get all


# Delete Services
kubectl delete svc my-first-service


# Delete Pod
kubectl delete pod my-first-pod


# Get all Objects in default namespace
kubectl get all

