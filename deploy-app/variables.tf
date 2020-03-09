variable "pod_label" {
  type = string
  default = "hello-world"
  description = "The label of the pod created"
}

variable "pod_replicas" {
  type = number
  default = 1
  description = "Number of pods"
}

variable "message" {
  type = string
  default = "hello world"
  description = "Message to display on homepage of the webapp"
}

variable "app_port" {
  type = number
  default = 80
  description = "Application listening port"
}

variable "docker_image" {
  type = string
  description = "Docker image to run"
}

variable "limits_memory" {
  type = string
  description = "Memory limit"
}

variable "requests_memory" {
  type = string
  description = "Request memory"
}

variable "limits_cpu" {
  type = string
  description = "CPU limit"
}

variable "requests_cpu" {
  type = string
  description = "Request CPU"
}

variable "probe_header" {
  type = string
  description = "Value for the proble header"
}

variable "endpoint_healthcheck" {
  type = string
  description = "Path for the healthcheck endpoint"
}
