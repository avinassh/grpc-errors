# C# gRPC
 
    $ protoc --plugin=protoc-gen-grpc=`which grpc_csharp_plugin` -I=../ --csharp_out Hello/Hello --grpc_out Hello/Hello ../hello.proto 