use std::sync::Arc;

use grpcio::{ChannelBuilder, EnvBuilder};

use rust::proto::hello::HelloReq;
use rust::proto::hello_grpc::HelloServiceClient;

fn main() {
    let env = Arc::new(EnvBuilder::new().build());
    let ch = ChannelBuilder::new(env).connect("localhost:50051");
    let client = HelloServiceClient::new(ch);

    let mut req = HelloReq::new();
    req.set_Name("Euler".to_owned());

    let reply = client.say_hello(&req);
    println!("{:?}", reply);

    // the failing case
    let mut req = HelloReq::new();
    req.set_Name("Leonhard Euler".to_owned());

    let reply = client.say_hello_strict(&req);
    println!("{:?}", reply);
}
