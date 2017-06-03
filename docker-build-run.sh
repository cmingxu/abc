#!/bin/bash

docker build -t abc .
docker rm -f rails-abc 2&> /dev/null
docker run --name rails-abc -p 0.0.0.0:3000:3000 -v  /var/run/docker.sock:/var/run/docker.sock -d abc


