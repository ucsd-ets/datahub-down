# datahub-down

Source code for datahub's alternate page. Works through nginx.

Note: Installing this chart along with the manual configurations creates a GLOBAL outage page for that particular error. Meaning, if 2 services are crashed resulting in 504s visible in the browser, then both pages will see the same 504 outage page. Currently, there's no technical way of creating custom errors for a given service.

## Configuration & Installation

### Modify the helm chart values

This chart should run on a node that will to be operational throughout the duration of the cluster's lifetime (e.g. k8s master node). The path for the HTML templates will be on the host its running on

```yaml
image: quay.io/kubernetes-ingress-controller/custom-error-pages-amd64:0.4

# where the pod runs
nodeSelector:
  kubernetes.io/hostname: its-dsmlp-master.ucsd.edu

tolerations:
- key: node-role.kubernetes.io/master
  effect: NoSchedule

namespace: default

# host path of the templates
nginxErrorPagesHostPath: /root/nginx-error-pages
```

### Modify argument to nginx deployment

Edit the `ingress-nginx-ingress-controller` deployment under the `default` namespace and add the `--default-backend-service=default/nginx-errors` switch to `args` of the under the `container` subfield. See example for details

```bash
kubectl get deployments -n default

kubectl edit deployment ingress-nginx-ingress-controller - n default

# add the  --default-backend-service=default/nginx-errors switch to the container args
      containers:
      - args:
        - /nginx-ingress-controller
        - --default-backend-service=default/nginx-errors
        - --election-id=ingress-controller-leader
        - --ingress-class=nginx
        - --configmap=default/ingress-nginx-ingress-controller
        - --enable-ssl-chain-completion=false
```

### modify the nginx annotations for the jupyterhub ingress

Edit the `jupyterhub-extra` ingress and add the following annotations:

```bash
nginx.ingress.kubernetes.io/proxy-read-timeout: "2"
```

Will decrease the timeout for the app to be responsive to 2 seconds. See example

```bash
kubectl edit ingress jupyterhub-extra -n jupyterhub

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    ingress.kubernetes.io/proxy-read-timeout: "2"
    nginx.ingress.kubernetes.io/proxy-connect-timeout: "2"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "2"
    kubernetes.io/ingress.class: nginx

```

### Add custom errors to nginx controller configamp

Edit the `ingress-nginx-ingress-controller` configmap under the `default` namespace and add the field `custom-http-errors` under `data` with the status codes you like as a comma delimited string like `"502,503"`. See example below

```
kubectl get configmap -n default

- apiVersion: v1
  data:
    custom-http-errors: 502,504
    enable-vts-status: "false"
  kind: ConfigMap
  metadata:
    creationTimestamp: "2019-10-16T22:06:49Z"
    labels:
      app: nginx-ingress
      chart: nginx-ingress-0.29.1
      component: controller
      heritage: Tiller
      release: ingress
```

### Install the helm chart

```bash
# download the repo & run
helm install --name datahub-down $(pwd)

# alternatively, use the helmfile
ssh <username>@its-dsmlp-master
cd /opt/kubeops
sudo helmfile -e dsmlp -l name=datahub-down -b $(which helm3) sync
```
