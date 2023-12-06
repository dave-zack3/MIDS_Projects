cd project

IMAGE_PREFIX=$(az account list --all | jq '.[].user.name' | grep -i berkeley.edu | awk -F@ '{print $1}' | tr -d '"' | tr -d "." | tr '[:upper:]' '[:lower:]' | tr '_' '-' | uniq)

NAMESPACE=davezack
TAG=$(git rev-parse --short HEAD)
sed "s/\[TAG\]/${TAG}/g" .k8s/overlays/prod/patch-deployment-project_copy.yaml > .k8s/overlays/prod/patch-deployment-project.yaml

# FQDN = Fully-Qualified Domain Name
IMAGE_NAME=project
ACR_DOMAIN=w255mids.azurecr.io
IMAGE_FQDN="${ACR_DOMAIN}/${IMAGE_PREFIX}/${IMAGE_NAME}"

az acr login --name w255mids
az account set -s 0257ef73-2cbf-424a-af32-f3d41524e705

TOKEN=$(az acr login --name w255mids --expose-token --output tsv --query accessToken)
docker login w255mids.azurecr.io --username 00000000-0000-0000-0000-000000000000 --password-stdin <<< $TOKEN

kubectl config use-context w255-aks

kubectl --namespace externaldns logs -l "app.kubernetes.io/name=external-dns,app.kubernetes.io/instance=external-dns"
kubectl --namespace istio-ingress get certificates ${NAMESPACE}-cert
kubectl --namespace istio-ingress get certificaterequests
kubectl --namespace istio-ingress get gateways ${NAMESPACE}-gateway

docker build --platform linux/amd64 -t ${IMAGE_NAME} .
docker tag ${IMAGE_NAME} ${IMAGE_FQDN}:${TAG}
docker push ${IMAGE_FQDN}:${TAG}

kubectl kustomize .k8s/overlays/prod -n ${NAMESPACE}
kubectl apply -k .k8s/overlays/prod -n ${NAMESPACE}

docker pull ${IMAGE_FQDN}:${TAG}