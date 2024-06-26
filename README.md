# projectM WebGL Demo

## Build the projectm-emscripten-builder image

    docker build --tag projectm-emscripten-builder .

## Build the demo

    ./build.sh

The demo will be built into the `build` directory. Serve this directory over HTTP and load `/demo.html` in a browser.

Python has the ability to serve a directory over HTTP from the command line using

    python -m http.server

If you don't have python installed you can use the python in the docker image, setting an alias for convenience:

    alias serve-dir='docker run -t --rm -u $(id -u):$(id -g) -v $(pwd):/src --network=host projectm-emscripten-builder python3 -m http.server'

After that you can build and serve the demo like this:

    ./build.sh && cd build && serve-dir && cd ..

Access the demo at http://127.0.0.1:8000/demo.html

### Windows version 


	build.bat && cd build && python -m http.server && cd ..


## Clean up

    unalias serve-dir
    docker rmi projectm-emscripten-builder
