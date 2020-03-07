variable "pod_label" {
  type = string
  default = "hello-world"
  description = "The label of the pod created."
}

variable "pod_replicas" {
  type = number
  default = 3
  description = "Number of pods."
}

variable "message" {
  type = string
  default = "hello world"
  description = "Message to display on homepage of the webapp."
}

variable "app_port" {
  type = number
  default = 80
  description = "Application listening port."
}

variable "docker_image" {
  type = string
  description = "Docker image to run."
}
