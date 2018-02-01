# CentOS 7 Ansible test image

![Build Status](https://img.shields.io/docker/build/kblr/centos7-ansible.svg) ![Automated](https://img.shields.io/docker/automated/kblr/centos7-ansible.svg) ![Pulls](https://img.shields.io/docker/pulls/kblr/centos7-ansible.svg) ![Stars](https://img.shields.io/docker/stars/kblr/centos7-ansible.svg)

CentOS 7 Docker image for Ansible role testing in Travis-CI.

> TL;DR: `docker pull kblr/centos7-ansible`


## Overview

I use Docker in Travis-CI to test my Ansible roles on multiple OS.

This repo allows me to (automatically) build a CentOS 7 image from the provided `Dockerfile`. This image contains the needed tools to run Ansible and the tests.

The image is built by Docker Hub automatically each time one of the following happens:
- the upstream OS container is updated;
- a commit is made on the `master` branch of this repo.


## How-to use with Travis-CI

Simply tell Travis to pull the image from Docker Hub and run a container based on it.

Your `.travis.yml` file should look like this:

```yaml
sudo: required
language: bash
services:
  - docker

before_install:
  # Pull the image from Docker Hub:
  - docker pull kblr/centos7-ansible:latest

script:
  # Run a container based on the previously pulled image:
  - >
    docker run
    --name "${TRAVIS_COMMIT}.centos7"
    --detach
    --privileged
    --mount type=bind,source=/sys/fs/cgroup,target=/sys/fs/cgroup,readonly
    --mount type=bind,source="$(pwd)",target=/etc/ansible/roles/under_test,readonly 
    kblr/centos7-ansible:latest

  # Execute tests:
  - >
    docker exec "${TRAVIS_COMMIT}.centos7"
    ansible-playbook -v /etc/ansible/roles/under_test/tests/test/yml --syntax-check

  - >
    docker exec ...

after_script:
  - docker rm -f "${TRAVIS_COMMIT}.centos7"

notifications:
  webhooks: https://galaxy.ansible.com/api/v1/notifications/
```


## How-to use locally

If you ever need to build the image manually:

  1. [Install Docker](https://docs.docker.com/engine/installation/)
  2. `git clone` this repo
  3. `cd` in the freshly cloned repo
  4. Build the image using `docker build --no-cache --rm --tag="centos7:ansible" .`
  5. `cd` in your Ansible role directory
  5. From there, run a container using `docker run --name [whatever] --detach --privileged --mount type=bind,source=/sys/fs/cgroup,target=/sys/fs/cgroup,readonly --mount type=bind,source="$(pwd)",target=/etc/ansible/roles/under_test,readonly centos7:ansible`


## Contributing

Code reviews, patches, comments, bug reports and feature requests are welcome. Please read the [Contributing Guide](CONTRIBUTING.md) for further details.
