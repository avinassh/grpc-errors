const PROTO_PATH = __dirname + '/../hello.proto';

var grpc = require('grpc');
var api = grpc.load(PROTO_PATH).hello;

function sayHello(call, callback) {
  callback(null, {Result: 'Hey, ' + call.request.Name + '!'});
}

function sayHelloStrict(call, callback) {
  if (call.request.Name.length >= 10) {
    return callback({
      code: grpc.status.INVALID_ARGUMENT,
      message: "Length of `Name` cannot be more than 10 characters",
    });
  }
  callback(null, {Result: 'Hey, ' + call.request.Name + '!'});
}

function main() {
  var server = new grpc.Server();
  server.addProtoService(api.HelloService.service,
    {sayHello: sayHello, sayHelloStrict: sayHelloStrict});
  server.bind('0.0.0.0:50051', grpc.ServerCredentials.createInsecure());
  server.start();
}

main();