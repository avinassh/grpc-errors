# Objective C gRPC

Note that this example has only client version of Objective C. For server, you can use any of the available server implementations. Following instructions show running a Go server.

## Instructions

Install the dependencies and generate protobuf file:

    $ pod install

Run the server ([instructions](../go/README.md)):
    
    $ ./server &

Run the client:

1. Open `HelloClient.xcworkspace`
2. Run