# projectM WebGL Demo

## Build the projectm-emscripten-builder image

    docker build --tag projectm-emscripten-builder .

## Build the demo

    ./build.sh

The demo will be built into the `build` directory. Serve this directory over HTTP and load `/demo.html` in a browser.

As Python has the ability to serve a directory over HTTP from the command line, you can set up an alias to do this using the same docker image:

    alias serve-dir='docker run -t --rm -u $(id -u):$(id -g) -v $(pwd):/src --network=host projectm-emscripten-builder python3 -m http.server'

After that you can build and serve the demo like this:

    ./build.sh && cd build && serve-dir && cd ..

Access the demo at http://127.0.0.1:8000/demo.html

## Clean up

    unalias serve-dir
    docker rmi projectm-emscripten-builder
