job "template" {
  datacenters = [var.datacenter]
  type = "batch"

  group "renderer" {
    task "output" {
      driver = var.driver

      config {
        command = local.os_command
        args = local.os_args
      }

      template {
        destination = "local/out.txt"

        # The HCL2 `file` function allows you to split out the template
        # into its own file. When you issue the `nomad job run` command,
        # the HCL2 engine inserts the files contents directly in place
        # before the job is submitted to Nomad.
        data =<<EOT
${file("./template.tmpl")}
EOT
      }
    }
  }
}

# These variables allow the job to have overridable default values
# for datacenter and driver.

variable "datacenter" {
  # Set the `NOMAD_VAR_datacenter` environment variable to override the 
  # default datacenter for the task.
  type = string
  default = "dc1"
}

variable "driver" {
  # Set the `NOMAD_VAR_driver` environment variable to override the
  # job's default task driver.
  type = string
  default = "raw_exec"
  validation {
    condition = var.driver == "raw_exec" || var.driver == "exec"
    error_message = "Invalid value for driver; valid values are [raw_exec, exec]."
  }
}

variable "os" {
  # Set the `NOMAD_VAR_os` environment variable to switch between posix and
  # windows workloads.
  type = string
  default = "linux"
  validation {
    condition = var.os == "linux" || var.os == "macos" || var.os == "windows"
    error_message = "Invalid value for os; valid values are [linux, macos, windows]."
  }
}

locals {
  linux_command="sh"
  linux_args=["-c","cat local/*"]
  win_command="powershell.exe"
  win_args=["-Command","& {Get-Content local/*}"]
  os_command="${var.os != "windows" ? local.linux_command : local.win_command}"
  os_args="${var.os != "windows" ? local.linux_args : local.win_args}"
}
