pub mod proto;

use crate::proto::hello::{HelloReq, HelloResp};
use crate::proto::hello_grpc::HelloService;

use futures::Future;
use grpcio::{RpcContext, RpcStatus, RpcStatusCode, UnarySink};

#[derive(Clone)]
pub struct GrpcHelloService;

impl HelloService for GrpcHelloService {
    fn say_hello(&mut self, ctx: RpcContext, req: HelloReq, sink: UnarySink<HelloResp>) {
        let name = req.get_Name();
        let reply_msg = format!("Hey, {}!", name);

        let mut reply = HelloResp::new();
        reply.set_Result(reply_msg);

        let f = sink
            .success(reply)
            .map_err(move |e| println!("failed to reply {:?}: {:?}", req, e));

        ctx.spawn(f);
    }

    fn say_hello_strict(&mut self, ctx: RpcContext, req: HelloReq, sink: UnarySink<HelloResp>) {
        let name = req.get_Name();

        if name.len() >= 10 {
            let reply_msg = "Length of `Name` cannot be more than 10 characters";

            let f = sink
                .fail(RpcStatus::new(
                    RpcStatusCode::InvalidArgument,
                    Some(reply_msg.to_string()),
                ))
                .map_err(move |e| println!("failed to reply {:?}: {:?}", req, e));

            ctx.spawn(f);
        } else {
            let reply_msg = format!("Hey, {}!", name);

            let mut reply = HelloResp::new();
            reply.set_Result(reply_msg);

            let f = sink
                .success(reply)
                .map_err(move |e| println!("failed to reply {:?}: {:?}", req, e));

            ctx.spawn(f);
        }
    }
}
