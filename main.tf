terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

provider "docker" {
  host = "npipe:////./pipe/docker_engine"
}



# Pulls the image
resource "docker_image" "lucky" {
  name = "ubuntu:latest"
}

# Create a container
resource "docker_container" "el_container" {
  image = docker_image.lucky.image_id
  name  = "notle_12"

  tty   = true
  stdin_open = true
}