# Provision a Local Docker Container with Terraform
This project demonstrates the use of Infrastructure as Code (IaC) with Terraform to provision a simple NGINX Docker container locally.

## 🚀 Objective
The goal is to write, plan, and apply a Terraform configuration to manage the lifecycle of a Docker container on your local machine. This serves as a fundamental example of using the Terraform Docker provider.

## 📋 Prerequisites
Before you begin, ensure you have the following tools installed and running on your system:

### Terraform: Download and install Terraform.

### Docker: Install Docker Desktop and make sure the Docker daemon is running.

## 📁 Project Structure
The repository contains a single Terraform configuration file:

main.tf: This file contains all the necessary HCL (HashiCorp Configuration Language) code to define the Docker provider, the Docker image to use, and the Docker container resource.

## ⚙️ Terraform Code (main.tf)
This is the core configuration file that tells Terraform what to do.

# main.tf

# 1. Configure the Docker Provider
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# 2. Define the Docker Image resource
# This will pull the latest NGINX image from Docker Hub.
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false # Set to true to keep the image after 'terraform destroy'
}

# 3. Define the Docker Container resource
# This creates a container from the NGINX image.
resource "docker_container" "nginx_server" {
  image = docker_image.nginx.image_id
  name  = "tutorial-nginx-server"

  ports {
    internal = 80
    external = 8080
  }
}

## 🛠️ Execution Steps
Follow these steps in your terminal to create and manage the infrastructure.

### 1. Initialize Terraform
First, navigate to the project directory and initialize the Terraform backend and provider plugins.

terraform init

Log Output:

Initializing the backend...
Initializing provider plugins...
- Finding kreuzwerker/docker versions matching "~> 3.0.1"...
- Installing kreuzwerker/docker v3.0.2...
- Installed kreuzwerker/docker v3.0.2 (signed by a HashiCorp partner, key ID F657F47038195C2B)

Terraform has been successfully initialized!

### 2. Plan the Deployment
Create an execution plan. The terraform plan command shows you what actions Terraform will take without actually performing them. This is a crucial step for verifying changes before applying them.

terraform plan

Log Output:

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # docker_container.nginx_server will be created
  + resource "docker_container" "nginx_server" { ... }

  # docker_image.nginx will be created
  + resource "docker_image" "nginx" { ... }

Plan: 2 to add, 0 to change, 0 to destroy.

### 3. Apply the Configuration
Apply the plan to create the Docker image and container. Terraform will ask for confirmation before proceeding.

terraform apply

Log Output:

...
Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

docker_image.nginx: Creating...
docker_image.nginx: Creation complete after 5s [id=sha256:6ef2d71a260227a456844a4823142159392b909c049740b35a3a1498e9485252nginx:latest]
docker_container.nginx_server: Creating...
docker_container.nginx_server: Creation complete after 1s [id=a8b3f4e2c1d...]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

### 4. Verify the Container
Check that the container is running using the docker ps command. You should see the tutorial-nginx-server container listed.

docker ps

# Log Output:

CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                  NAMES
a8b3f4e2c1d9   6ef2d71a2602   "/docker-entrypoint.…"   2 minutes ago   Up 2 minutes   0.0.0.0:8080->80/tcp   tutorial-nginx-server

You can also access the NGINX welcome page by navigating to http://localhost:8080 in your web browser.

5. Check Terraform State
Inspect the current state of your managed infrastructure using the terraform state command. This shows which resources Terraform is currently managing.

terraform state list

# Log Output:

docker_container.nginx_server
docker_image.nginx

6. Destroy the Infrastructure
When you are finished, you can tear down all the resources created by this configuration. Terraform will again ask for confirmation.

terraform destroy

# Log Output:

Plan: 0 to add, 0 to change, 2 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

docker_container.nginx_server: Destroying...
docker_container.nginx_server: Destruction complete after 1s
docker_image.nginx: Destroying...
docker_image.nginx: Destruction complete after 0s

Destroy complete! Resources: 2 destroyed.

After running destroy, you can verify with docker ps that the container has been removed.
