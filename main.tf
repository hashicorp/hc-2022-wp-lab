variable "region" {
  description = "The AWS region to deploy to."
  default     = "ca-central-1"
}

provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_ecs_cluster" "wp-ecs-cluster" {
  # Default name expected by Waypoint runner install command
  name = "waypoint-server"
}