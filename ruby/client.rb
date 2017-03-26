#!/usr/bin/env ruby

this_dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(this_dir) unless $LOAD_PATH.include?(this_dir)

require 'grpc'
require_relative 'hello_services_pb'

def main
  stub = Hello::HelloService::Stub.new('localhost:50051', :this_channel_is_insecure)
  response = stub.say_hello(Hello::HelloReq.new(name: 'Euler'))
  p "#{response.result}"

  # lets try the failing case
  begin
    response = stub.say_hello_strict(Hello::HelloReq.new(name: 'Leonhard Euler'))
  rescue GRPC::BadStatus => e
    # ouch!
    # lets print the gRPC error message
    # which is "Length of `Name` cannot be more than 10 characters"
    puts "#{e.details}"
    # Want its int version for some reason?
    # you shouldn't actually do this, but if you need for debugging,
    # you can access `e.code` which will give you `3`
    #
    # puts "#{e.code}"
    # 
    # Want to take specific action based on specific error?
    if e.code == GRPC::Core::StatusCodes::INVALID_ARGUMENT
      # do your thing here
    end
  end
end

main
