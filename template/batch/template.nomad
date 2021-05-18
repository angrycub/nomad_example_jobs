job "template" {
  datacenters = ["dc1"]
  type = "batch"
  task "command" {
    driver = "exec"
    config {
      command = "cat"
      args = ["local/template.out"]
    }
    template {
      destination = "local/template.out"
      data = <<EOH
Hello.
EOH

    }
  }
}

