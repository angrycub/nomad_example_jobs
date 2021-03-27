job "java-driver-test.nomad" {
  datacenters = ["dc1"]
  type = "batch"

  # constraint {
  #   attribute = "${attr.unique.hostname}"
  #   operator  = "="
  #   value     = "nomad-client-1.node.consul"
  # }

  group "test" {
    task "test" {
      artifact {
        source = "https://github.com/angrycub/JavaDriverTest/releases/download/v0.0.2/JavaDriverTest.jar"
        destination = "local/"
      }

      driver = "java"

      config {
        class = "JavaDriverTest"
        class_path = "local/JavaDriverTest.jar"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
