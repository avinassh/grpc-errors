# Go gRPC
    
## Instructions

Generate protobuf files:

    $ protoc -I ../ ../hello.proto --go_out=hello --go_opt=module=github.com/avinassh/grpc-errors/go/hello
    $ protoc -I ../ ../hello.proto --go-grpc_out=hello --go-grpc_opt=module=github.com/avinassh/grpc-errors/go/hello

Build server and client, and run:

    $ go build server.go
    $ go build client.go
    $ ./server &
    $ ./client