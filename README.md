# datahub-down

Source code for datahub's alternate page. Works through nginx.

Note: Installing this chart along with the manual configurations creates a GLOBAL outage page for that particular error. Meaning, if 2 services are crashed resulting in 504s visible in the browser, then both pages will see the same 504 outage page. Currently, there's no technical way of creating custom errors for a given service.

## Installation

### Install the helm chart

```bash
helm install --name datahub-down $(pwd)
```

### Add annotations to nginx deployment

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



## Development

For errors outside of