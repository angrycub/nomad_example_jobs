# The host volume configuration for the minio task. The start.sh
# script will make a derived copy of this file with the place-
# holder--«/absolute/path/to»--replaced with the output of `pwd`

client {
    host_volume "minio-data" {
        path      = "«/absolute/path/to»/minio-data"
        read_only = false
  }
}
