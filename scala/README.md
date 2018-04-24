# Scala gRPC

## Instructions

Scala uses the [ScalaPB](https://github.com/scalapb/ScalaPB) SBT plugin, which can integrate with SBT and generate idiomadic Scala code for those that do not want to use grpc-java directly

To run, in *separate terminals*:

    $ sbt "runMain hello.server.HelloServer"
    $ sbt "runMain hello.client.HelloClient"
