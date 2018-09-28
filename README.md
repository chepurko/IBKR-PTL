# IBKR-PTL
Interactive Brokers Gateway with PTL Trader + VNC

## Deploying to a Kubernetes cluster

### Prerequisites
* This repository is generally for Google Cloud Platform but can be adapted to other infrastructure
* You need a working Kubernetes cluster (outside the scope of this repo). I am using Google Kubernetes Engine (GKE) but you can use your own cluster on Google Compute Engine (GCE) or any other cloud provider with only slight adaptation i.e. disk creation
  * You can start here if you are a beginner - [official Kubernetes guide](https://kubernetes.io/docs/setup/turnkey/gce/ "Running Kubernetes on Google Compute Engine")
* You need the Google Cloud SDK for this example - [installing Google Cloud SDK](https://cloud.google.com/sdk/install)

### Create a disk and a volume in GCE

```bash
gcloud compute disks create --size=5GB --zone=[your-gce-zone] ibkr-ptl
kubectl apply -f gce-volume.yaml
```

### Create the namespace, password to login to VNC with, and the deployment

```bash
kubectl apply -f 00-namespace.yaml
kubectl create secret generic vnc-pw --from-literal=password=[your-password] --namespace=ibkr-ptl
kubectl apply -f ibkr-ptl-Deployment.yaml
```

## Starting a VNC session

This deployment is based on the Docker image from [ConSol/docker-headless-vnc-container](https://github.com/ConSol/docker-headless-vnc-container) so you have the option of starting a traditional VNC session and connecting to it with any VNC client (RealVNC for example) or you can use noVNC and login through your browser.

All connections are done to `localhost` and are completely encrypted and secured by the built-in Kubernetes `kubectl port-forward` command. In other words, you are opening an encrypted connection to you cluster, and forwarding ports from your cluster to your `localhost` where you can safely connect to VNC. Additionally, we create a password for the VNC server itself.

### To use traditional VNC:

```bash
kubectl port-forward --namespace=ibkr-ptl ibkr-ptl-[podnumber] 5901:5901
```

And connect to `localhost:5901` from your preferred VNC client.

### To use noVNC HTML5 client with your browser:

```bash
kubectl port-forward --namespace=ibkr-ptl ibkr-ptl-[podnumber] 6901:6901
```

And open a browser and enter the address http://localhost:6901/vnc.html

Using either option you should be prompted to enter the VNC password you set in the `kubectl create secret` step before.
