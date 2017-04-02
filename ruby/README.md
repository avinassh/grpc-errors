# Ruby gRPC

## Instructions

Install the dependencies:

    $ gem install grpc
    $ gem install grpc-tools

Generate protobuf files:

    $ grpc_tools_ruby_protoc -I ../ --ruby_out=. --grpc_out=. ../hello.proto

Run the server and client:

    $ ruby server.rb &
    $ ruby client.rb

Note: 

There is some issue the way gRPC files are being generated, the class seems have capitalised symbols, which is not allowed. So I had to edit them manually.