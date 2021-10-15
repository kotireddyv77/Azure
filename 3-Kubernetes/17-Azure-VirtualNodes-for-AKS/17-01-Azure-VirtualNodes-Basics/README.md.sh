---
title: Azure Kubernetes Service AKS Virtual Nodes
description: Create Azure Kubernetes Services (AKS) cluster to use virtual nodes
---

# Azure Kubernetes Service AKS Virtual Nodes (Serverless)

## Step-01: Introduction
- What is [Virtual Kubelet](https://github.com/virtual-kubelet/virtual-kubelet)?
- What is [Azure Container Instances - ACI](https://docs.microsoft.com/en-us/azure/container-instances/)?
- What are [AKS Virtual Nodes](https://docs.microsoft.com/en-us/azure/aks/virtual-nodes-portal)?
- **Important Note:** Virtual nodes require AKS clusters with [Azure CNI networking](https://docs.microsoft.com/en-us/azure/aks/configure-azure-cni)

## Step-02: Create a new cluster using Azure Management Console
- Register Provider in Subscription - Microsoft.ContainerInstance
- **Basics**
  - **Subscription:** Free Trial or Pay-as-you-go
  - **Resource Group:** Creat New: aks-rg2
  - **Kubernetes Cluster Name:** aksdemo2
  - **Region:** (US) Central US
  - **Kubernetes Version:** Select what ever is latest stable version
  - **Node Size:** Standard DS2 v2 (Default one)
  - **Node Count:** 1
- **Node Pools**
  - **Virtual Nodes:** Enabled
  - leave to defaults
- **Authentication**
  - Authentication method: 	System-assigned managed identity
  - Rest all leave to defaults
- **Networking**
  - **Network Configuration:** Advanced
  - **Network Policy:** Azure
  - Rest all leave to defaults
- **Integrations**
  - Azure Container Registry: None
  - leave to defaults
- **Tags**
  - leave to defaults
- **Review + Create**
  - Click on **Create**


### Enable Virtual Nodes in AKS
- Create a subnet in the Resource group which has vmss. Subnet Name - subnet-virtual-nodes
- Update aks name, rg name and run below commands

az aks enable-addons --addons virtual-node --name  "atingupta-AKSCluster" --resource-group "rg-atingupta-aks-cluster" --subnet "subnet-virtual-nodes"



## Step-03: Verify Nodes & ACI

# Configure Command Line Credentials
az aks get-credentials --name aksdemo2 --resource-group aks-rg2


# Verify Nodes
kubectl get nodes


kubectl get nodes -o wide


# Verify aci-connector-linux
kubectl get pods -n kube-system


# Verify logs of ACI Connector Linux
kubectl logs -f $(kubectl get po -n kube-system | egrep -o 'aci-connector-linux-[A-Za-z0-9-]+') -n kube-system

- We should see `virtual-node-aci-linux` node also listed for `kubectl get nodes` output
- **Sample Output**

kubectl get nodes


## Step-04: Update Deployment Manifest to Schedule Pod on Virtual Nodes
- The below section should be added in Deployment for Azure AKS to schedule the pod on Azure Virtual Nodes
- Review the manifests
yaml
      nodeSelector:
        kubernetes.io/role: agent
        beta.kubernetes.io/os: linux
        type: virtual-kubelet
      tolerations:
      - key: virtual-kubelet.io/provider
        operator: Exists
      - key: azure.com/aci
        effect: NoSchedule


## Step-05: Deploy Application Manifests

# Deploy
kubectl apply -f kube-manifests/


# Verify pods
kubectl get pods -o wide


# Get Public IP
kubectl get svc


# Access Application
curl http://<Public-ip-captured-from-get-service>


## Step-06: Scale the Deployment

# List Deployments
kubectl get deploy


# Scale the Deployment to 10 Replicas
kubectl scale --replicas=10 deployment app1-nginx-deployment


# List Pods
kubectl get pods


## Step-07: Clean-Up

# Delete Application
kubectl delete -f kube-manifests/


# Delete this new cluster created for Virtual Nodes (if you want to)
az aks delete --name aksdemo2 --resource-group aks-rg2


## References
- [Azure Virtual Nodes - Limitations](https://docs.microsoft.com/en-us/azure/aks/virtual-nodes-cli#known-limitations)
- [Virtual kubelet - Referece - 1](https://github.com/virtual-kubelet/virtual-kubelet)
- [Virtual kubelet - Referece - 2](https://github.com/virtual-kubelet/azure-aci/blob/master/README.md)
- [Virtual Node Autoscale - Optional & legacy](https://github.com/Azure-Samples/virtual-node-autoscale)
