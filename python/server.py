import time
from concurrent import futures

import grpc

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
