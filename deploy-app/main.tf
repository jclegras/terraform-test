provider "kubernetes" {}

resource "kubernetes_config_map" "config" {
  metadata {
    name = "hello-config"
  }
  
  data = {
    GREETING_MSG = var.message
  }
}

resource "kubernetes_network_policy" "app_network_policy" {
  metadata {
    name = "application-traffic"
  }
  spec {
    policy_types = ["Ingress", "Egress"]

    pod_selector {
      match_labels = {
        app = "${kubernetes_deployment.deployment.spec[0].template[0].metadata[0].labels.app}"
      }
    }

    ingress {
        ports {
          port = var.app_port
          protocol = "TCP"
        }

        from {
          namespace_selector {
            match_labels = {
              name = "default"
            }
          }
        }
    }

    egress {} # single empty rule to allow all egress traffic

  }
}

resource "kubernetes_service" "svc" {
  metadata {
    name = "hello-world-svc"
  }
  
  spec {
    selector = {
      app = "${kubernetes_deployment.deployment.spec[0].template[0].metadata[0].labels.app}"
    }

    port {
      port        = 80
      target_port = var.app_port
    }

    type = "NodePort"
  }  
}

resource "kubernetes_deployment" "deployment" {
  metadata {
    name = "hello-world-deployment"
    labels = {
      app = "hello-world"
    }
  } 
  
  spec {
    replicas = var.pod_replicas
    
    selector {
      match_labels = {
        app = var.pod_label
      }
    }
    
    template {
      metadata {
        labels = {
          app = var.pod_label
        }
      }       
    
      spec {
        container {
          image = var.docker_image
          name  = "greeting"
          
          port {
		    container_port = var.app_port
          }

          resources {
            limits {
              memory = var.limits_memory
              cpu = var.limits_cpu
            }
            requests {
              memory = var.requests_memory
              cpu = var.requests_cpu
            }
          }
          
          env_from {
            config_map_ref {
              name =  "hello-config"
            }
          }
          
          liveness_probe {
            http_get {
              path = var.endpoint_healthcheck
              port = var.app_port

              http_header {
                name  = "X-Probe"
                value = var.probe_header
              }
            }
            
            initial_delay_seconds = 3
            period_seconds        = 3               
          }             
        }
      }
    }
  }
}
