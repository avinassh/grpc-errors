# Go gRPC
    
## Instructions

Generate protobuf files:

    $ protoc -I ../ ../hello.proto --go_out=plugins=grpc:./hello

Build server and client, and run:

    $ go build server.go
    $ go build client.go
    $ ./server &
    $ ./client