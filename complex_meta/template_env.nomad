job "template" {
  datacenters = ["dc1"]
  type = "batch"
  group "group" {
    count = 1
    task "meta-output" {
    
template {
  data = <<EOH
{{- define "RULES" -}}
[
  {
    "cloudwatch":{
      "asg_cpu_usage_upper_bound": { 
        "backend":"test-backend",
        "dimension_name":"AutoScalingGroupName",
        "metric_namespace": "AWS/EC2",
        "metric_name": "CPUUtilization"
      }
    },
    "enabled": true
  },
  {
    "rule2":{
      "foos":[
       {"foo1": "bar"},
       {"foo2": "bar2"}
     ],
     "enabled": true
    }
  }
]
{{- end }}
RULES={{ executeTemplate "RULES" | toJSON }}
EOH

  destination = "secrets/rules.env"
  env         = true
}

  driver = "raw_exec"
      resources { memory = 10 }
      config { 
        command = "bash"
        args=["-c", "echo $RULES | jq ."]
      }
    }
  }
}
