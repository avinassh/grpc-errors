# Rust gRPC

gRPC-errors example using rust.

It uses the [grpc-rs](https://github.com/pingcap/grpc-rs) crate which is a rust
wrapper of [grpc](https://github.com/grpc/grpc).

## System requirements

- CMake >= 3.8.0
- rustup: You can install `rustup` on your system follow the [install
  instructions](https://doc.rust-lang.org/book/ch01-01-installation.html) of
  the rust documentation.

## Instructions

The generation of the protobuf files is integrated into the cargo build stage
(see [build.rs](./build.rs)) so there is no extra step to generate the files.

Run server:
```bash
$ cargo run --bin server
```

Run client:
```bash
$ cargo run --bin client
```


