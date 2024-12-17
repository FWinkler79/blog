---
modify_date: 2021-01-04 00:06:00
title: Cross-building Docker Images on Your Mac
tags: raspberry-pi
cover: /images/docker_cover.png
---

![Image]({{ site.baseurl }}/images/docker.png){:.rounded}

If you're like me and currently are infatuated with Docker and Raspberry Pi, or if you are just generally interested in separating the development and runtime environment, you might like this next blog. Indeed, there is a cool Docker feature that let's you build images for different hardware platforms.

<!--more-->

## Problem Statement

Recently I wanted to build a Docker image containing a Spring Boot application that I wanted to run on my Raspberry Pi - using Docker, of course. As it turns out, building a Docker image with a Spring Boot app is rather simple, however, if you do so on your Mac / Linux / Windows machine, you will not be able to run the image on Raspberry Pi.

The reason is, of course, that Docker images are hardware architecture-specific, meaning that a Docker image built on Mac with an x86_64 CPU architecture will not start on a Raspberry Pi with an arm32v7 architecture chip.

> Note: you can find out the architecture your Raspberry Pi is using by typing `uname -a` on the command line. The output will look something like this:
> ```
> Linux raspberrypi 5.4.72-v7l+ #1356 SMP Thu Oct 22 13:57:51 BST 2020 armv7l GNU/Linux
> ```
> Note the `armv7l` in the output. That's the architecture your Raspbian uses.

## The Simple Solution

The simple solution to that problem would be to build everything on the architecture that it should run on, e.g. build the Spring Boot application and docker image on Raspberry Pi instead of a Mac / Linux / Windows machine. However that has a few downsides:

* **Build speed** - The Raspi arm32v7 chip is a little monster, but it's nothing compared to a full-blown Mac with an x86 chip inside and 32 GB of RAM. Besides, you probably develop on your Mac all the time, so that's where all your tools are. You'll be faster on the Mac for sure - build and development-wise.

* **You pollute your Raspberry Pi** - Basically you would turn your Raspi into your  development environment, when really all you want it be is your production environment, i.e. the tiny always-on server that runs your home and favourite media center.

* **Development turnaround cycles** - Most likely you develop on your Mac / Linux / Windows machine, and then will push your changes to a Github that you then fetch from on your Raspi before triggering a build. Made a mistake? Do it again! You get the point - it sucks.

## The Better Solution

The better solution to the problem described above is to use Docker's Cross Build feature, which is still rather new, but works like a charm already.

Docker provides a kind of "cross-build" feature using the `buildx` command, which is rather easy to use.

Given a Dockerfile, all you need to do to build it for a different architecture is this:

```bash
# Listing existing docker buildx builders. You can see which architectures are supported.
docker buildx ls

# Create docker buildx builder named 'raspibuilder'
docker buildx create --name raspibuilder

# Use 'raspibuilder' for docker buildx
docker buildx use raspibuilder

# Cross-building Docker image for Raspi
docker buildx build --platform linux/arm/v7 -t <docker-user-name>/<image-name>:<version> --push .
```

The last of the commands above uses the `buildx` command to cross-build a docker image for the Raspberry Pi (`linux/arm/v7`), tags the image and pushes it to Docker Hub. It uses the `Dockerfile` located in the current directory (`.`) to build the image.

After that you can pull the image onto your Raspberry Pi (executing a docker pull there) and run it.

❗Note: You can also build images for multiple architectures at once and push them. See [Docker Multi-Arch Builds and Cross Builds](https://docs.docker.com/docker-for-mac/multi-arch/) for details. For a list of available Raspberry Pi arm32v7-compatible base images have a look here: [arm32v7 Docker Images](https://hub.docker.com/u/arm32v7)

Happy cross-building!

P.S.: Needless to say that you cannot only cross-build for arm32v7 architectures. Here is a list of the currently supported ones on my system: 
```bash
linux/amd64, linux/arm64, linux/riscv64, linux/ppc64le, linux/s390x, linux/386, linux/arm/v7, linux/arm/v6
```
## References

* [Docker Multi-Arch Builds and Cross Builds](https://docs.docker.com/docker-for-mac/multi-arch/)
* [arm32v7 Docker Images](https://hub.docker.com/u/arm32v7)
* [arm64v8 Docker Images](https://hub.docker.com/u/arm64v8)
* [Docker Official Images](https://github.com/docker-library/official-images?tab=readme-ov-file#architectures-other-than-amd64)
* [Docker Official Alpine arm64v8 Image](https://hub.docker.com/r/arm64v8/alpine)
* [Alpine Official arm64v8 image](https://hub.docker.com/layers/library/alpine/latest/images/sha256-cf7e6d447a6bdf4d1ab120c418c7fd9bdbb9c4e838554fda3ed988592ba02936)

