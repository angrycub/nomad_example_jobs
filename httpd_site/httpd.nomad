job "httpd_site" {
  datacenters = ["dc1"]
  type = "service"
  update {
    stagger = "5s"
    max_parallel = 1
  }
  group "httpd" {
    count = 1
    network {
      port "http" {
        to = 80
      }
    }

    task "httpd-docker" {
      artifact {
        source = "https://raw.githubusercontent.com/angrycub/nomad_example_jobs/master/httpd_site/site-content.tgz"
        destination = "tarball"
      }
      driver = "docker"
      config {
        image = "httpd:2.4-alpine"
        volumes = [
          "tarball:/usr/local/apache2/htdocs"
        ]
        ports = ["http"]
      }
      resources {
        cpu = 200
        memory = 32
      }
    }
  }
}
