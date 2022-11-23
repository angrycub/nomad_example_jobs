job "ingress-gateway" {
  datacenters = ["dc1"]

  group "group" {
    network {
      port "envoy" {}
    }

    task "ingress-gateway" {
      driver = "docker"

      config {
        image        = "voiselle/ingress-gateway:latest"
        network_mode = "host"
        command      = "/bin/sh"
        args         = ["-c", "while true; do sleep 10; done"]
        mounts       = [
          {
            type   = "bind"
            target = "/etc/consul.d/ig-services/ingress-gateway.hcl"
            source = "local/ingress-gateway.hcl"
            readonly = true
          }
        ]
      }

      env = {
        "CONSUL_HTTP_ADDR"  = "${NOMAD_IP_envoy}:8500"
        "CONSUL_HTTP_TOKEN" = "c62d8564-c0c5-8dfe-3e75-005debbd0e40",
        "CONSUL_ENVOY_IP"   = "${NOMAD_IP_envoy}",
        "CONSUL_ENVOY_PORT" = "${NOMAD_PORT_envoy}"
      }

      template {
        destination = "local/ingress-gateway.hcl"
        data        = <<EOH
Kind = "ingress-gateway"
Name = "ingress-service"

Listeners = [
 {
   Port = 8080
   Protocol = "http"
   Services = [
     {
       Name = "count-dashboard"
     }
   ]
 }
]
EOH
      }
    }
  }
}
