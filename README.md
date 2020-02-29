# docker-jekyll-ghc

GHC on jekyll/builder (on Alpine Linux)

See [ednutting/jekyll-ghc on Docker](https://hub.docker.com/repository/docker/ednutting/jekyll-ghc)

See my other repositories for GHC-Up, Stack and Agda on Jekyll/builder.

## Using this docker image

Don't `FROM` this image directly. You don't need to. You only need a subset of the files included
in this image in order to use `ghc`.

See the Dockerfile in my docker-jekyll-stack repo for the variables and files you need.

Note: Give your Docker instance 4 CPUs and 8GB RAM minimum or the build may randomly fail.
