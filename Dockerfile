# Build:
#     docker build --tag projectm-emscripten-builder .
#
# Run:
#     docker run --rm -t -u $(id -u):$(id -g) -v $(pwd):/src projectm-emscripten-builder emcc ...

FROM emscripten/emsdk:3.1.61

ARG PROJECTM_VERSION=4.1.1

RUN apt-get update && apt-get install -y --no-install-recommends \
        # libprojectM build tools and dependencies
        # https://github.com/projectM-visualizer/projectm/wiki/Building-libprojectM#install-the-build-tools-and-dependencies
        libgl1-mesa-dev \
        libglm-dev \
        mesa-common-dev \
    && rm -rf /var/lib/apt/lists/* \
    # download projectM
    && wget https://github.com/projectM-visualizer/projectm/releases/download/v$PROJECTM_VERSION/libprojectM-$PROJECTM_VERSION.tar.gz \
    && tar xzf libprojectM-*.tar.gz \
    && rm libprojectM-*.tar.gz \
    && cd libprojectM-* \
    # build projectM
    # https://github.com/projectM-visualizer/projectm/blob/master/BUILDING-cmake.md
    && mkdir build \
    && cd build \
    && emcmake cmake .. \
        -D CMAKE_BUILD_TYPE=Release \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D ENABLE_EMSCRIPTEN=1 \
    && emmake cmake \
        --build . \
        --target install \
        --config Release \
    # allow container to be run as a non-root user
    && chmod 777 /emsdk/upstream/emscripten/cache/symbol_lists*
