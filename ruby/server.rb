#!/usr/bin/env ruby

this_dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(this_dir) unless $LOAD_PATH.include?(this_dir)

require 'grpc'
require 'hello_services_pb'

class HelloServer < Hello::HelloService::Service

  def say_hello(hello_req, _unused_call)
    Hello::HelloResp.new(result: "Hey, #{hello_req.name}!")
  end

  def say_hello_strict(hello_req, _unused_call)
    if hello_req.name.length >= 10
        msg = 'Length of `Name` cannot be more than 10 characters'
        raise GRPC::BadStatus.new(GRPC::Core::StatusCodes::INVALID_ARGUMENT, msg)
    end
    Hello::HelloResp.new(result: "Hey, #{hello_req.name}!")
  end

end

def main
  s = GRPC::RpcServer.new
  s.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
  s.handle(HelloServer)
  s.run_till_terminated
end

main
