# ETH2 Prysm Node

Helm Chart and utilities for deploying an ETH2 Prysm Node on Kubernetes Environments

This chart was built for my own purposes to deploy on my own private kubernetes cluster which runs on top of many of the products from Rancher.

However while I've taken some steps to try and make it generic so that it can be used on any cloud kubernetes deployment, I want to be clear, that it has not been tested by me on any other cloud provider. If anyone wants to test, and confirm, I'm happy to accept feedback and update the docs. Or feel free to make changes, and issue a PR.

Just wanted to try to make it easy to deploy an ETH2 Validator node on a resilient scalable infrastructure so that any can benefit.

Also I'd like to note that there are likely many improvements possible to further secure things. Better use of a more "robust" secrets manager for example would be ideal, but currently with the state of Prysm it doesn't support direct integration to that type of service, so hacking one on would provide diminishing returns for the effort.

I will try to continue updating this in prep for the full ETH2 mainnet launch, but welcome any contributions and assistance.

# Installing

## Get the chart
**These instructions assume you are using linux/unix like terminal with bash or something equivalent. Or WSL on windows, etc.**
First off, get this chart locally, so clone this repo

## Customize your settings
Now edit the file in the root of the repo called `custom-values.yaml` to customize for your specific needs/environment.

Pay special attention to the `web3ProviderURL` field, ensure you've gone to infura, and setup your own account with an API key (for the appropriate networks)

Also pay attention to things like graffiti, the statsConfig section, and any hostnames/urls

**This chart deploys resources with persistant storage. This is important because your beacon and validator will store sensitive info here**

The defaults assume your kubernetes environment has a working Persistant Volume Provisioner which can provision a PVC (Persistant Volume Claim). And that it's set as default. If this is not the case, you may have to customize the volume configs.

Also if you enable TLS on the ingress for the grafana dashboard, you may need cert-manager installed correctly to issue certs, or some equivalent in your kube environment.

## Generate your validator keys/deposits
Use the official ETH2 Validator Launchpad at: https://medalla.launchpad.ethereum.org/

Go through the entire process, understand the risks, etc...

When complete, you will have a folder most likely named `validator_keys` with your deposit json files, and you will have transmitted the deposit transactions.

**Ensure you keep these files safe. Along with your backup mnemonic phrases, etc.**

## Deploy to kubernetes
From the root of the repo, assuming you have your kubectl client configured correctly, first create a namespace:
```
kubectl create namespace my-prysm-node
```

Now navigate to the folder which contains your `validator_keys` folder within it. (your current directory should be one folder above the `validator_keys` folder)

Once there, we will create a folder and file to contain your validator password you created during the launchpad process.

**This is only temporary, and this file should be deleted when done to keep this password secure**
```
mkdir passwords
vi passwords/password.txt
```
Now using vi, enter the password you provided to the launchpad on the first line of the file, in plain text. Then save the file.

*The reason we use an editor to do this, is that we don't want to have the password show up in your console command history, feel free to use method of your choice*

Now that we have the file structure right, we need to create 2 kubernetes secrets in the namespace we have already created for your prysm node. These will separately contain the password, and the validator key files for import on validator node startup. **Note the last line of this script deletes the password folder/file**
```
kubectl --namespace my-prysm-node create secret generic validator-passwords --from-file=./passwords
kubectl --namespace my-prysm-node create secret generic validator-keys --from-file=./validator_keys
rm -rf ./passwords
```

Finally we will deploy the helm chart to the prepared kubernetes environment.

(we will need to change working directory back to the root of the repo for this)
```
helm upgrade --namespace my-prysm-node --install prysm-node -f ./custom-values.yaml ./prysm-node
```

## Wait for everything to come up...
You can watch the pods coming up, wait until all pods are in ready state:
```
kubectl get pods --namespace my-prysm-node
```

Once they are all in ready state, if you enabled the ingress for the grafana dashboard, you should be able to check it's status with:
```
kubectl get ingress --namespace orb0-prysm-medalla
```
There may be more to it than that if you enabled TLS, etc... But if you've configured those things I'm assuming you know how to check their status.

Provided all is working, you should eventually be able to hit up the grafana dashboard in your browser at the indicated host address for the ingress.

If you didn't enable the ingress, then you can use kubernetes port forwarding to reach into the service which should be named `prysm-grafana` inside the namespace you created.

# For more info

## Prism
For details on the prysm project itself see:

https://prylabs.net/

https://github.com/prysmaticlabs/prysm

## Validator/Staking Launchpad:
https://medalla.launchpad.ethereum.org/

Follow the process, will generate files, then deploy this helm chart...
