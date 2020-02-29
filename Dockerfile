ARG JEKYLL_GHCUP_IMAGE=ednutting/jekyll-ghcup:latest

FROM $JEKYLL_GHCUP_IMAGE

# Note: Give your Docker instance 4 CPUs and 8GB RAM minimum or the build may randomly fail

## Sections of this script for building GHC are modified from:
## https://github.com/jkachmar/alpine-haskell-stack/blob/master/Dockerfile

###################################################
#   GHC
###################################################

# Carry build args through to this stage
ARG GHC_BUILD_TYPE=gmp
ARG GHC_VERSION=8.6.5

RUN echo "Install OS packages necessary to build GHC" &&\
    apk add --no-cache \
    autoconf \
    automake \
    binutils-gold \
    build-base \
    coreutils \
    cpio \
    ghc \
    linux-headers \
    libffi-dev \
    llvm5 \
    musl-dev \
    ncurses-dev \
    perl \
    python3 \
    py3-sphinx \
    zlib-dev

COPY make-ghc/build-gmp.mk /tmp/build-gmp.mk
COPY make-ghc/build-simple.mk /tmp/build-simple.mk
RUN if [ "${GHC_BUILD_TYPE}" = "gmp" ]; then \
    echo "Using 'integer-gmp' build config" &&\
    apk add --no-cache gmp-dev &&\
    mv /tmp/build-gmp.mk /tmp/build.mk && rm /tmp/build-simple.mk; \
    elif [ "${GHC_BUILD_TYPE}" = "simple" ]; then \
    echo "Using 'integer-simple' build config" &&\
    mv /tmp/build-simple.mk /tmp/build.mk && rm tmp/build-gmp.mk; \
    else \
    echo "Invalid argument \[ GHC_BUILD_TYPE=${GHC_BUILD_TYPE} \]" && exit 1; \
    fi

RUN echo "Compiling and installing GHC" &&\
    LD=ld.gold \
    SPHINXBUILD=/usr/bin/sphinx-build-3 \
    ghcup -v compile -j $(nproc) -c /tmp/build.mk ${GHC_VERSION} ghc-8.4.3 &&\
    rm /tmp/build.mk &&\
    echo "Uninstalling GHC bootstrapping compiler" &&\
    apk del ghc &&\
    ghcup set ${GHC_VERSION}
