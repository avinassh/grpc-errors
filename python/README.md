# Python gRPC
    
## Instructions

Install the dependencies:

    $ pip install -r requirements.txt

Generate protobuf files:

    $ python -m grpc_tools.protoc -I../ --python_out=. --grpc_python_out=. ../hello.proto

Run client and server:

    $ python server.py &
    $ python client.py