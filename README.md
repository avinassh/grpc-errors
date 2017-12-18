# gRPC Errors - A handy guide to gRPC errors.

This repository contains code examples in different languages which demonstrate handling errors in gRPC.

Check the [`hello.proto`](hello.proto) file to see the gRPC method definitions. It has two methods `SayHello` and `SayHelloStrict`:

    func SayHello(name) {
        return "Hey, (name)!"
    }

`SayHelloStrict` is similar, but throws an error if the length of name is more than 10 characters.

Each language directories have instructions to generate gRPC methods in respective languages. I assume that you have done the basic [tutorials](http://www.grpc.io/docs/quickstart/).

## Guide

Check this page for quick guide and examples of all languages - [gRPC Errors](http://avi.im/grpc-errors)

## System Requirements
    
- [gRPC](https://github.com/grpc/grpc/blob/master/INSTALL.md)
- [protobuf compiler](https://github.com/google/protobuf)

## License

The mighty MIT license. Please check `LICENSE` for more details.