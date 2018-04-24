name := "scala"

version := "0.1"

scalaVersion := "2.11.12"

// these two is to make sure we only compile the one proto in the root of the repo and ignore other protos that may
// get pulled in from npm install, virtualenvs in python, etc
includeFilter in PB.generate := "hello.proto"
PB.protoSources in Compile := Seq(baseDirectory.value / "..")

PB.targets in Compile := Seq(
  scalapb.gen() -> (sourceManaged in Compile).value
)

libraryDependencies ++= Seq(
  "io.grpc" % "grpc-netty" % scalapb.compiler.Version.grpcJavaVersion,
  "com.thesamet.scalapb" %% "scalapb-runtime-grpc" % scalapb.compiler.Version.scalapbVersion
)

