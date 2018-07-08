#!/usr/bin/env bash

# Takes every tag defined in the bio.yml role and outputs a Docker build line
# to test it in isolation on Travis CI.
# Add the output to the scripts section of .travis.yml and then edit as required.
#

ansible-playbook --list-tags bio.yml | \
  grep "TASK TAGS:" | \
  sed "s/TASK TAGS: \[//" | \
  python3 -c '

import sys

template = """\
  - travis_wait 300 docker build --pull=false --build-arg TASK_TAGS={tag} -t bioansible:{tag} -f docker/Dockerfile-bio-tags-travis .
  - travis_wait 300 docker rmi bioansible:{tag}
"""

tags=sys.stdin.read().split(",")
[print(template.format(tag=t.strip())) for t in tags]
' # end python
