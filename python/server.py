import time
from concurrent import futures

import grpc
from google.rpc import status_pb2, code_pb2
from google.protobuf import any_pb2
from grpc_status import rpc_status

import hello_pb2
import hello_pb2_grpc

_ONE_DAY_IN_SECONDS = 60 * 60 * 24


class HelloServicer(hello_pb2_grpc.HelloServiceServicer):

    def SayHello(self, request, context):
        return hello_pb2.HelloResp(Result="Hey, {}!".format(request.Name))

    def SayHelloStrict(self, request, context):
        if len(request.Name) >= 10:
            msg = 'Length of `Name` cannot be more than 10 characters'
            context.set_details(msg)
            context.set_code(grpc.StatusCode.INVALID_ARGUMENT)
            return hello_pb2.HelloResp()

        return hello_pb2.HelloResp(Result="Hey, {}!".format(request.Name))

    def SayHelloAdvanced(self, request, context):
        if len(request.Name) >= 10:
            # with the error, you can also send any proto object as metadata. We will use the one we defined in the
            # proto definition
            # so create an api.Error obj and send that along with the error.
            desc = F"Your name contains {len(request.Name)} characters, but you cannot use more than 10 characters in this API request"
            my_err = hello_pb2.Error(Description=desc)
            # we need to wrap our obj in any.Any object
            detail = any_pb2.Any()
            detail.Pack(my_err)
            err_status = status_pb2.Status(
                code=code_pb2.INVALID_ARGUMENT,
                message='Length of `Name` cannot be more than 10 characters',
                details=[detail],
            )
            context.abort_with_status(rpc_status.to_status(err_status))
            return hello_pb2.HelloResp()

        return hello_pb2.HelloResp(Result="Hey, {}!".format(request.Name))

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    hello_pb2_grpc.add_HelloServiceServicer_to_server(HelloServicer(), server)
    server.add_insecure_port('[::]:50051')
    server.start()
    try:
        while True:
            time.sleep(_ONE_DAY_IN_SECONDS)
    except KeyboardInterrupt:
        server.stop(0)


if __name__ == '__main__':
    serve()
