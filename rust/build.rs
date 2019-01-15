use std::path::Path;

fn main() {
    let proto_out = "src/proto";
    let proto_root = Path::new("../").canonicalize().unwrap();
    let proto_file = Path::new("../hello.proto").canonicalize().unwrap();

    protoc_grpcio::compile_grpc_protos(
        &[proto_file],
        &[proto_root],
        &proto_out
    ).expect("Failed to compile gRPC definitions!");
}
