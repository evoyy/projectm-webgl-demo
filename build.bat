SET EMCC=docker run -t --rm -v %cd%:/src projectm-emscripten-builder emcc

IF EXIST build\ (
    rmdir /S /Q build\
)
mkdir build

%EMCC% ^
    -I /usr/local/include ^
    -l embind ^
    -o build/projectm.js ^
    -s ALLOW_MEMORY_GROWTH=1 ^
    -s ENVIRONMENT=web ^
    -s EXPORTED_FUNCTIONS=_add_audio_data ^
    -s EXPORTED_RUNTIME_METHODS=ccall ^
    -s EXPORT_NAME=createModule ^
    -s FULL_ES2=1 -s FULL_ES3=1 ^
    -s MIN_WEBGL_VERSION=2 -s MAX_WEBGL_VERSION=2 ^
    -s MODULARIZE=1 ^
    --embed-file textures ^
    --embed-file presets ^
    demo.cpp /usr/local/lib/libprojectM-4.a

copy demo.html build\
copy demo.js build\
copy demo.mp3 build\