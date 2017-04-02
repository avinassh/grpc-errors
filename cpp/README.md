# CPP gRPC

## Instructions

Generate protobuf files:

    $ protoc -I ../ --grpc_out=. --plugin=protoc-gen-grpc=`which grpc_cpp_plugin` ../hello.proto

    $ protoc -I ../ --cpp_out=. ../hello.proto

Compile client and server:

    $ g++ -std=c++11 -I/usr/local/include -pthread  -c -o client.o client.cpp

    $ g++ hello.pb.o hello.grpc.pb.o client.o -L/usr/local/lib `pkg-config --libs grpc++ grpc` -lgrpc++_reflection -lprotobuf -lpthread -ldl -o client

    $ g++ -std=c++11 -I/usr/local/include -pthread  -c -o server.o server.cpp

    $ g++ hello.pb.o hello.grpc.pb.o server.o -L/usr/local/lib `pkg-config --libs grpc++ grpc` -lgrpc++_reflection -lprotobuf -lpthread -ldl -o server

Run client and server:

    $ ./server &
    $ ./client

