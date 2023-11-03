# Graylog

Graylog is a log-aggregating solution. This sample job runs
the Graylog 5 Docker container.


## Variables

- `datacenters` (type: list(string), default: ["dc1"]) - The datacenters in which to run the job.

- `graylog_version` (type: string, default: "5.0") - The container tag to pull.


## Checks

```
HEALTHCHECK \
  --interval=10s \
  --timeout=2s \
  --retries=12 \
  CMD /health_check.sh
```

1. `password_secret` (environment variable `GRAYLOG_PASSWORD_SECRET`)
    - A secret that is used for password encryption and salting.
    - Must be at least 16 characters, however using at least 64 characters is strongly recommended.
    - Must be the same on all Graylog nodes in the cluster.
    - May be generated with something like:

    ```bash
    pwgen -N 1 -s 96
    ```

1. `root_password_sha2` (environment variable `GRAYLOG_ROOT_PASSWORD_SHA2`)
    - A SHA2 hash of a password you will use for your initial login as Graylog's root user.
    - The default username is admin. This value is customizable via configuration option root_username (environment variable GRAYLOG_ROOT_USERNAME).
    - In general, these credentials will only be needed to initially set up the system or reconfigure the system in the event of an authentication backend failure.
    - This password cannot be changed using the API or via the Web interface.
    - May be generated with something like:

    ```bash
    echo -n "Enter Password: " && head -1 </dev/stdin | tr -d '\n' | sha256sum | cut -d" " -f1
    ```