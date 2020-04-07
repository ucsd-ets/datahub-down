export K8S_NAMESPACE=default

PROD_VALUES_PATH=/home/wuykimpang/datahub-down/values-prod.yaml
DEV_VALUES_PATH=/home/wuykimpang/datahub-down/values-dev.yaml

alias PROD_INSTALL='helm install --name datahub-down $(pwd) --values $PROD_VALUES_PATH --tls'
alias DEV_INSTALL='helm install --name datahub-down $(pwd) --values $DEV_VALUES_PATH --tls'

alias PROD_UPGRADE='helm upgrade datahub-down $(pwd) --values $PROD_VALUES_PATH --tls'
alias DEV_UPGRADE='helm upgrade datahub-down $(pwd) --values $DEV_VALUES_PATH --tls'

alias PROD_DELETE='helm del --purge datahub-down --tls'
alias DEV_DELETE='helm del --purge datahub-down --tls'