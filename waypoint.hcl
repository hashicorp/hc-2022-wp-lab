# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "registry_username" {
  type = string
  default = ""
  env = ["REGISTRY_USERNAME"]
}

variable "registry_password" {
  type = string
  sensitive = true
  default = ""
  env = ["REGISTRY_PASSWORD"]
}

variable "registry_imagename" {
  type = string
  default = ""
  env = ["REGISTRY_IMAGENAME"]
}

variable "aws_region" {
  type = string
  default = ""
  env = ["TF_VAR_region"]
}

project = "hc-lab-hat-hat-demo"

app "dev" {
  build {
    use "docker" {}
    registry {
      use "docker" {
        image = "${var.registry_username}/${var.registry_imagename}"
        tag = "dev"
        local = false
        auth {
          username = var.registry_username
          password = var.registry_password
        }
      }
    }
  }

  deploy {
    use "docker" {
      service_port = 3000
      static_environment = {
        PLATFORM = "docker (dev)"
      }
    }
  }
}

app "ecs" {
  runner {
    profile = "ecs-ECS-RUNNER"
  }

  build {
    use "docker" {}
    registry {
      use "docker" {
        image = "${var.registry_username}/${var.registry_imagename}"
        tag = "testing"
        local = false
        auth {
          username = var.registry_username
          password = var.registry_password
        }
      }
    }
  }

  deploy {
    use "aws-ecs" {
      service_port = 3000
      static_environment = {
        PLATFORM = "aws-ecs (ca-central)"
      }
      region = var.aws_region
      memory = 512
    }
  }
}

// app "kubernetes" {
//   runner {
//     profile = "kubernetes-KUBE-RUNNER"
//   }

//   build {
//     use "docker" {}
//     registry {
//       use "docker" {
//         image = "${var.registry_username}/${var.registry_imagename}"
//         tag = "testing"
//         local = false
//         auth {
//           username = var.registry_username
//           password = var.registry_password
//         }
//       }
//     }
//   }

//   deploy {
//     use "kubernetes" {
//       probe_path = "/"
//       service_port = 3000
//       static_environment = {
//         PLATFORM = "kubernetes (us-west)"
//       }
//       memory {
//         request = "64Mi"
//         limit   = "128Mi"
//       }

//       autoscale {
//         min_replicas = 1
//         max_replicas = 5
//         cpu_percent = 20
//       }
//     }
//   }

//   release {
//     use "kubernetes" {
//       load_balancer = true
//       port          = 3000
//     }
//   }
// }