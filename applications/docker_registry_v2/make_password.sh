#!/bin/bash

docker run --rm -it -v $(pwd):/out --entrypoint="htpasswd" xmartlabs/htpasswd -Bbc /out/$1 $2 $3
