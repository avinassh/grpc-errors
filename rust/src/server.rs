use std::io::Read;
use std::sync::Arc;
use std::{io, thread};

use futures::sync::oneshot;
use futures::Future;
use grpcio::{Environment, ServerBuilder};

use rust::proto::hello_grpc;
use rust::GrpcHelloService;

fn main() {
    let env = Arc::new(Environment::new(1));
    let service = hello_grpc::create_hello_service(GrpcHelloService);

    let mut server = ServerBuilder::new(env)
        .register_service(service)
        .bind("0.0.0.0", 50051)
        .build()
        .unwrap();

    server.start();
    for &(ref host, port) in server.bind_addrs() {
        println!("Server listening on {}:{}", host, port);
    }

    let (tx, rx) = oneshot::channel();
    thread::spawn(move || {
        println!("Press ENTER to exit...");
        let _ = io::stdin().read(&mut [0]).unwrap();
        tx.send(())
    });

    let _ = rx.wait();
    let _ = server.shutdown().wait();
}
