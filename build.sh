#!/bin/bash

docker build -t jrcs/crashplan:dev . && \
docker push jrcs/crashplan:dev
