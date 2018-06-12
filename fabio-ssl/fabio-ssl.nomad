job "fabio-stg" { 
datacenters = ["dc1"] 
type = "system"

group "fabio" { 
task "fabio" { 
driver = "docker"

config { 
volumes = [ 
"/etc/fabio:/etc/fabio" 
]

image = "fabiolb/fabio" 
port_map { 
lb = 9999 
https = 443 
ui = 9998 
http = 80 
} 
}

resources { 
cpu = 1000 
memory = 70 
network { 
mbits = 1 
port "lb" { 
static = "9999" 
} 
port "https" { 
static = "443" 
} 
port "http" { 
static = "80" 
} 
port "ui" { 
static = "9998" 
} 
} 
}

service { 
name = "fabio-lb" 
tags = ["fabio"] 
port = "http"

check { 
type = "tcp" 
port = "http" 
path = "/" 
interval = "10s" 
timeout = "2s" 
} 
} 
service { 
name = "fabio-lb-tls" 
tags = ["fabio"] 
port = "https"

check { 
type = "tcp" 
port = "https" 
path = "/" 
interval = "10s" 
timeout = "2s" 
}

} 
service { 
name = "fabio-ui" 
tags = ["fabio"] 
port = "ui"

check { 
type = "tcp" 
port = "ui" 
path = "/" 
interval = "10s" 
timeout = "2s" 
}

} 
} 
} 
}
