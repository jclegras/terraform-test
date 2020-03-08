output "service_port" {
  value = "${kubernetes_service.svc.spec.0.port.0.node_port}"
}