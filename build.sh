#!/bin/bash -eu

EMCC="docker run -t --rm -u $(id -u):$(id -g) -v $(pwd):/src projectm-emscripten-builder emcc"

rm -rf build
mkdir build

# https://github.com/projectM-visualizer/projectm/blob/master/docs/emscripten.rst#additional-build-settings
#  - force the use of WebGL 2, which is required for OpenGL ES 3 emulation
#  - enable full emulation support for both OpenGL ES 2.0 and 3.0 variants
#  - allow allocating additional memory. This may be required to load additional textures etc. in projectM.
$EMCC \
    -I /usr/local/include \
    -l embind \
    -o build/projectm.js \
    -s ALLOW_MEMORY_GROWTH=1 \
    -s ENVIRONMENT=web \
    -s EXPORTED_FUNCTIONS=_add_audio_data \
    -s EXPORTED_RUNTIME_METHODS=ccall \
    -s EXPORT_NAME=createModule \
    -s FULL_ES2=1 -s FULL_ES3=1 \
    -s MIN_WEBGL_VERSION=2 -s MAX_WEBGL_VERSION=2 \
    -s MODULARIZE=1 \
    --embed-file textures \
    --embed-file presets \
    demo.cpp /usr/local/lib/libprojectM-4.a

cp demo.html demo.js demo.mp3 build
