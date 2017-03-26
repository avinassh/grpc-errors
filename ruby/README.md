# Ruby gRPC

    $ grpc_tools_ruby_protoc -I ../ --ruby_out=. --grpc_out=. ../hello.proto

Note: 

There is some issue the way gRPC files are being generated, the class seems have capitalised symbols, which is not allowed. So I had to edit them manually.