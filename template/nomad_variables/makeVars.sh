#!/bin/bash

echo '{"Items":{"k1":"v1","k2":"v2"}}' | nomad operator api '/v1/var/my/var/a'
echo '{"Items":{"k1":"v1","k2":"v2"}}' | nomad operator api '/v1/var/my/var/b'
echo '{"Items":{"k1":"v1","k2":"v2"}}' | nomad operator api '/v1/var/other/var/a'

