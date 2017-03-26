#include <iostream>
#include <memory>
#include <string>

#include <grpc++/grpc++.h>

#include "hello.grpc.pb.h"

using grpc::Channel;
using grpc::ClientContext;
using grpc::Status;
using grpc::StatusCode;
using hello::HelloReq;
using hello::HelloResp;
using hello::HelloService;

class HelloServiceClient {
 public:
  HelloServiceClient(std::shared_ptr<Channel> channel)
      : stub_(HelloService::NewStub(channel)) {}

  std::string SayHello(const std::string& name) {
    HelloReq request;
    request.set_name(name);
    HelloResp response;
    ClientContext context;

    Status status = stub_->SayHello(&context, request, &response);
    // ideally you should check for errors here too before
    // returning the response
    return response.result();
  }

  void SayHelloStrict(const std::string& name) {
    HelloReq request;
    request.set_name(name);
    HelloResp response;
    ClientContext context;

    Status status = stub_->SayHelloStrict(&context, request, &response);

    if (status.ok()) {
      return;
    } else {
      // ouch!
      // lets print the gRPC error message
      // which is "Length of `Name` cannot be more than 10 characters"
      std::cout << status.error_message() << std::endl;
      // lets print the error code, which is 3
      std::cout << status.error_code() << std::endl;
      // want to do some specific action based on the error?
      if(status.error_code() == StatusCode::INVALID_ARGUMENT) {
        // do your thing here
      }
      return;
    }
  }

 private:
  std::unique_ptr<HelloService::Stub> stub_;
};

int main(int argc, char** argv) {
  HelloServiceClient client(grpc::CreateChannel(
      "localhost:50051", grpc::InsecureChannelCredentials()));
  std::cout << client.SayHello("Euler") << std::endl;

  // the failing case
  client.SayHelloStrict("Leonhard Euler");
  
  return 0;
}