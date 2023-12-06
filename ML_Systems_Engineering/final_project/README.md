# README

## General Overview

The goal of this project was to deploy a more advanced model API to an online service provider (in
this case `Azure Kubernetes Service (AKS)`). This was accomplished by building
and pushing the API image to `Azure Container Registry (ACR)` and deploying the
API using `istio` and `kustomize`. No changes were made to the API defined in 
previous labs but a description of what the API is able to do locally follows 
below.

In previous labs we were tasked with extending our FastAPI application that 
supports a `/hello` endpoint and takes a name parameter. The 
application now also serves `/predict` and `/health` endpoints. The `predict`
endpoint now accepts a list of the pydantic class "house" and outputs a 
list of "house prices". This application's dependencies are managed with `poetry` 
and the functionality is tested using `pytest`. The repo also contains a 
`Dockerfile` which packages the application and runs it in a multi-stage 
fashion and a `run.sh` file that demonstrates the code working. 
Additionally, github actions have been added to ensure the 
application is tested on pull requests. The application now deploys locally in 
a Kubernetes environment (Minikube).This `README.md` serves as 
an outline of the project execution.

- [General Overview](#general-overview)
- [How to Run](#how-to-run)
- [How to Test](#how-to-test)
- [How to Deploy](#how-to-deploy)

## How to Test

To test the application, you must first have `poetry` installed on your machine. After it is installed you can 
simply run the following command in the `root` folder (the one containing `pyproject.toml`).

- `poetry run pytest`

After running that command all the tests outlined above will be executed. As of the time of writing this 
`README.md` file, all tests pass.

## How to Deploy

The best method of deploying the application is located in the `build-push.sh` script. A summary follows.

1. Get the DNS appropriate namespace for cloud deployment (in my case, davezack)
2. Get the most recent git commit short hash tag that is used by the production application
3. Login to both `ACR` and `docker`
4. Change the context in `minikube` to `w255-aks`
5. Use a series of `kubectl` commands to create all the appropriate `istio` ingress points.
6. Build the image in a linux amd64 environment 
7. Tag the image with the short hash from git
8. Use `kustomize` to apply the API to the cloud setting
9. Pull the most recent image with the tag for completeness