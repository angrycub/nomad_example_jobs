
bind_addr = "127.0.0.1"

advertise {
  http = "127.0.0.1"
  rpc  = "127.0.0.1"
  serf = "127.0.0.1"
}

server {
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled = true
}

# added for client config to use credStore to avoid storing auth
# deets in jobspecs
plugin "docker" {
  config {
    auth {
      helper = "nomadvariables"
    }
  }
}