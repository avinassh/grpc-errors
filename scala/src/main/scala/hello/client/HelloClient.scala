package hello.client

import hello.hello.HelloServiceGrpc.{HelloServiceBlockingClient, HelloServiceStub}
import hello.hello.{HelloReq, HelloResp, HelloServiceGrpc}
import io.grpc.{ManagedChannelBuilder, StatusRuntimeException}

import scala.concurrent.{Await, ExecutionContext, Future}
import scala.concurrent.duration._

object HelloClient {
  val goodReq = HelloReq("Euler")
  val badReq = HelloReq("Leonhard Euler")

  def main(args: Array[String]): Unit = {
    val channel = ManagedChannelBuilder
      .forAddress("localhost", 50051)
      .usePlaintext(true)
      .build()

    val asyncStub = HelloServiceGrpc.stub(channel)
    val blockingStub: HelloServiceGrpc.HelloServiceBlockingStub = HelloServiceGrpc.blockingStub(channel)
    implicit val executionContext = ExecutionContext.global

    blockingExample(blockingStub)
    asyncExample(asyncStub)
  }

  def blockingExample(stub: HelloServiceBlockingClient): Unit = {
    println("Starting blocking example")
    val syncResp = stub.sayHello(goodReq)
    println(syncResp.result)

    try {
      stub.sayHelloStrict(badReq)
    } catch {
      case rtEx: StatusRuntimeException =>
        println(s"Blocking implementation description ${rtEx.getStatus.getDescription} and code ${rtEx.getStatus.getCode}")
    }
  }

  def asyncExample(stub: HelloServiceStub)(implicit ec: ExecutionContext): Unit = {
    println("Starting async example")
    val f1: Future[HelloResp] = stub.sayHello(goodReq)
    val f2: Future[HelloResp] = stub.sayHelloStrict(badReq)

    f1.onSuccess {
      case HelloResp(result: String) => println(result)
    }
    f2 onFailure {
      case rtEx: StatusRuntimeException =>
        println(s"Async implementation description ${rtEx.getStatus.getDescription} and code ${rtEx.getStatus.getCode}")
    }

    Await.ready(Future.sequence(Seq(f1, f2)), 1.second)
  }
}

