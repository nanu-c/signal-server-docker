Docker container to run a Signal server
-----------------------------------------

This relies on the user providing the textsecure and push server jars in
jar/ and the config files under config/.

See the Dockerfile comments for how to build the image. The container can
be run from the root of this repository.

Docs
----------
https://github.com/LiteSpeedDev/SignalApp-Setup

Build
-----------
* install Docker

* initialise git submodule
`git submodule init&&
git submodule update`
* build 
`./build-server`

Run
-----------
`docker run -p 8080:8080 -p 8081:8081 -P -v $(pwd)/config:/home/whisper/config -it signal-server`

Using https
-----------

You can generate a root CA, host key and certificates and keystores for the server
using the gencert scripts, for example if your server is running on 192.168.1.100

ALTNAME=IP:192.168.1.100 ./gencerts

Copy the resulting example.keystore to config/ as referenced by tsconfig.yml and
the rootCA.crt file to the client (pointed at by the rootCA config item in the Go client).
