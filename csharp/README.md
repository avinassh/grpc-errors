# C# gRPC

## Instructions

C# examples use Xamarin studio. To generate protobuf files:
 
    $ protoc --plugin=protoc-gen-grpc=`which grpc_csharp_plugin` -I=../ --csharp_out Hello/Hello --grpc_out Hello/Hello ../hello.proto

## To run

1. Open the solution `Hello.sln` with Xamarin Studio.
2. Install the dependencies: `Project` -> `Restore NuGet Packages`
3. Build the solution
4. Run server and client