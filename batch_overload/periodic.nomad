job "example" {
  datacenters = ["dc1"]
  type        = "batch"

  periodic {
    prohibit_overlap = true
    crons            = [
      "*/15 * * * * *"
    ]
  }

  group "sleepers" {
    count = 5

    task "wait" {
      driver = "raw_exec"

      config {
        command = "bash"
        args    = [
          "-c",
          "echo Starting; sleep=`shuf -i5-10 -n1`; echo Sleeping $sleep seconds.; sleep $sleep; echo Done; exit 0"
        ]
      }

      resources {
        # This will cause us to have to create blocking allocs.
        memory = 200
      }
    }
  }
}
