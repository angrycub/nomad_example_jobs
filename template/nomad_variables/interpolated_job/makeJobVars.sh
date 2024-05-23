#!/bin/bash

echo '{"Items":{"version":"4","image":"redis"}}' | nomad operator api '/v1/var/nomad/jobs/example'

echo '{"Items":{"k1":"v1","k2":"v2"}}' | nomad operator api '/v1/var/nomad/jobs/variable'
echo '{"Items":{"k1":"v1","k2":"v2"}}' | nomad operator api '/v1/var/nomad/jobs/variable/www'
echo '{"Items":{"k1":"v1","k2":"v2"}}' | nomad operator api '/v1/var/nomad/jobs/variable/www/nginx'
