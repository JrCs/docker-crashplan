#!/bin/bash

docker build -t jrcs/crashplan . && \
docker push jrcs/crashplan
