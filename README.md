# kelaasor-DevOps-final-project

# Project description

Implementation of the full DevOps stack for CI/CD applications, including monitoring and logging.

## First step \- Installing prerequisites and initial setup

Install the following via Ansible:

- Docker  
- [Kind](https://kind.sigs.k8s.io/) cluster with one controller and two worker nodes  
- Nginx  
- [node\_exporter](https://github.com/prometheus/node_exporter)  
- Prometheus \+ Grafana using Docker Compose  
- Docker image registry using Docker Compose  
- GitLab Runner

## Second step \- Firewall

- Setting the firewall through iptables so that node_exporter is only accessible through Docker.
- Configuring the firewall so that the SSH port is not available for IP addresses 10.10.10.1, 10.10.10.2, 10.10.10.3, and 10.10.10.4 (via ipset and iptables).
- Saving iptables rules so that they are not deleted after a reboot.

## Third step \- Dockerize

Dockerize the application and follow best practices to reduce the size of the image.

## Fourth step \- CI/CD for dev environment

- Writing the GitLab CI job so that after receiving a merge request, it will be built on the dev branch and pushed to the image registry.
- Deploy through Docker Compose on port 8081.
- The pushed image tag must match the short commit SHA.

## Fifth step \- CI/CD for stage environment

- Build and push to the image registry after each commit or merge request on the main branch.
- The tag of this image should match the value of the version key in appinfo.json. Bash and jq can be used for this.
- Deploy using blue-green and zero-downtime methods on ports 8082 and 8083.
- A Bash script can be used for switching.
- During deployment, there should be no downtime in servicing the application.
- NGINX can also be used for load balancing and high availability (HA) between blue and green.

## Sixth step \- GitOps

- Creating Kubernetes-related manifests (e.g., Deployment, Service) and placing them in the Git repository for GitOps CD. Two copies of the application must be deployed on each worker (total of 4 replicas).
- Installing and connecting ArgoCD to the kind cluster and GitLab.
- Setting up the CI pipeline for the Production Environment so that after tagging each commit, its corresponding image is deployed on the Kubernetes cluster.
- Creating a ReverseProxy through NGINX for the prod.DOMAIN.TLD domain to enable HA and Load Balancing between workers.

# Optional items

- Installing Loki and maintaining NGINX logs on it.
- Installing Alert Manager and setting up alert notifications via Telegram or email in cases of increased load, full main disk, or full server RAM.
- Installing Minio and maintaining Loki logs on it.
- Creating or updating changelog.txt in the Git repository root directory automatically based on the text of commits (assuming compliance with conventional commits) in the development pipeline.
- Handling DevSecOps cases and conducting security tests.
- Setting up backups and writing the Disaster Recovery Plan (DRP).