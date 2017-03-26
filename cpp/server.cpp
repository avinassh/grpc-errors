#include <iostream>
#include <memory>
#include <string>

#include <grpc++/grpc++.h>

#include "hello.grpc.pb.h"

using grpc::Server;
using grpc::ServerBuilder;
using grpc::ServerContext;
using grpc::Status;
using hello::HelloReq;
using hello::HelloResp;
using hello::HelloService;

class HelloServiceImpl final : public HelloService::Service {

  Status SayHello(ServerContext* context, const HelloReq* request,
                  HelloResp* reply) override {
    std::string prefix("Hey ");
    reply->set_result(prefix + request->name());
    return Status::OK;
  }

  Status SayHelloStrict(ServerContext* context, const HelloReq* request,
                  HelloResp* reply) override {
    // TODO: set errors
    // check length of `request->name()`, if its equal or more than 10
    // characters then send an error
    // error status code: grpc.status.Invalid_Argument
    // error message: Length of `Name` cannot be more than 10 characters
    std::string name(request->name());
    if (name.length() >= 10) {
      // set errors here
      // Status::Error Message
      // Status::Error Code
    }
    std::string prefix("Hey ");
    reply->set_result(prefix + name);
    return Status::OK;
  }

};

void RunServer() {
  std::string server_address("0.0.0.0:50051");
  HelloServiceImpl service;
  ServerBuilder builder;
  builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
  builder.RegisterService(&service);
  std::unique_ptr<Server> server(builder.BuildAndStart());
  std::cout << "Server listening on " << server_address << std::endl;
  server->Wait();
}

int main(int argc, char** argv) {
  RunServer();
  return 0;
}
