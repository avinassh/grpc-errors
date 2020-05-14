# Go gRPC
    
## Instructions

Install the go protobuf plugin required:

	$ go get github.com/golang/protobuf/protoc-gen-go
	$ go install github.com/golang/protobuf/protoc-gen-go

Generate protobuf files:

    $ protoc -I ../ ../hello.proto --go_out=plugins=grpc:./hello

Build server and client, and run:

    $ go build server.go
    $ go build client.go
    $ ./server &
    $ ./client