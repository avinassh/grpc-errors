# CPP gRPC

    $ protoc -I ../ --grpc_out=. --plugin=protoc-gen-grpc=`which grpc_cpp_plugin` ../hello.proto

    $ protoc -I ../ --cpp_out=. ../hello.proto

    g++ -std=c++11 -I/usr/local/include -pthread -I/Users/avi/.tmp/delete/grpc/include -c -o hello.grpc.pb.o hello.grpc.pb.cc

    g++ -std=c++11 -I/usr/local/include -pthread -I/Users/avi/.tmp/delete/grpc/include -c -o server hello.grpc.pb.o hello.pb.o server.cpp

    g++ -std=c++11 -I/usr/local/include -pthread -I/Users/avi/.tmp/delete/grpc/include -c -o client hello.grpc.pb.o hello.pb.o client.cpp
