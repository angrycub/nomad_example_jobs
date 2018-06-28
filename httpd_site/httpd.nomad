job "httpd_site" {
  datacenters = ["dc1"]
  type = "service"
  update {
    stagger = "5s"
    max_parallel = 1
  }
  group "httpd" {
    count = 1
    task "httpd-docker" {
      artifact {
        source = "https://angrycub-hc.s3.amazonaws.com/public/templated-industrious.zip"
        destination = "tarball"
      }
      driver = "docker"
      config {
        image = "httpd:2.4-alpine"
        volumes = [
          "tarball:/usr/local/apache2/htdocs"
        ]
        port_map {
          http = 80
        }      
      }
      resources {
        cpu = 200
        memory = 32
        network {
          port "http" {}
        }
      }
    }
  }
}
