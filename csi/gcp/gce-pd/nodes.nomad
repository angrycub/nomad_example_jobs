job "nodes" {
  datacenters = ["dc1"]
  type = "system"
  group "nodes" {
    task "plugin" {
      driver = "docker"
      template {
        data = <<EOH
{{ key "service_account" }}
EOH
  destination = "secrets/creds.json"
      }
      env { "GOOGLE_APPLICATION_CREDENTIALS" = "/secrets/creds.json"
      }
      config {
        image = "gcr.io/gke-release/gcp-compute-persistent-disk-csi-driver:v0.7.0-gke.0"
        args = [
          "--endpoint=unix:///csi/csi.sock",
          "--v=6",
          "--logtostderr",
          "--run-controller-service=false"
        ]
        privileged = true
      }
      csi_plugin {
        id        = "gcepd"
        type      = "node"
        mount_dir = "/csi"
      }
      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
