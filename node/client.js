const PROTO_PATH = __dirname + '/../hello.proto';

var grpc = require('grpc');
var api = grpc.load(PROTO_PATH).hello;

function main() {
  var client = new api.HelloService('localhost:50051', grpc.credentials.createInsecure());

  client.sayHello({Name: 'Euler'}, function(err, response) {
    // check for `err` here too, which I am ignoring for brevity
    console.log(response.Result);
  });

  client.sayHelloStrict({Name: 'Leonhard Euler'}, function(err, response) {
    if (err) {
      // ouch!
      // lets print the gRPC error message
      // which is "Length of `Name` cannot be more than 10 characters"
      console.log(err.message)
      // Want to take specific action based on specific error?
      if (err.code === grpc.status.INVALID_ARGUMENT) {
        // your code here
      }
    }
  });
}

main();