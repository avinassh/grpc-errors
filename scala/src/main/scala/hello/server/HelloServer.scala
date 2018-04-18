package hello.server

import hello.hello.{HelloReq, HelloResp, HelloServiceGrpc}
import io.grpc.{ServerBuilder, Status}

import scala.concurrent.{ExecutionContext, Future}

object HelloServer {
  def main(args: Array[String]): Unit = {
    val svc = HelloServiceGrpc.bindService(new HelloServer(), ExecutionContext.global)
    ServerBuilder
      .forPort(50051)
      .addService(svc)
      .build()
      .start()
      .awaitTermination()
  }
}

class HelloServer extends HelloServiceGrpc.HelloService {
  override def sayHello(request: HelloReq): Future[HelloResp] = {
    Future.successful(HelloResp(result=s"Hello ${request.name}"))
  }

  override def sayHelloStrict(request: HelloReq): Future[HelloResp] = {
    if (request.name.length >= 10) {
      Future.failed(
        Status
          .INVALID_ARGUMENT
          .augmentDescription("Length of `Name` cannot be more than 10 characters")
          .asRuntimeException()
      )
    } else {
      Future.successful(HelloResp(result=s"Hello ${request.name}"))
    }
  }
}
