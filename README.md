gRPC is an amazing library, however, the documentation lacks details on error handling. The code examples do not contain error handling part either (though few does seem to have them). Some test suits in main repo do have them, but it might be difficult to figure out for a beginner.

This project is my attempt to fix the issue. The [repository](https://github.com/avinassh/grpc-errors) contains examples in all popular languages and contain similar implementations of server and client across languages and also, error handling. So you can run server in one language of your choice and client in another, error handling still works seamlessly. The rest of this page shows how to send errors from server, handle them in client, in different languages.

- [C++](#c)
- [C#](#c-1)
- [Go](#go)
- [Node](#node)
- [Objective C](#objective-c)
- [Python](#python)
- [Ruby](#ruby)
- [Swift](#swift)
- [Scala](#scala)
- [Rust](#rust)

## C++

Check the complete example [here](https://github.com/avinassh/grpc-errors/tree/master/cpp).

### Server

To send an error, return an instance of `grpc::Status` with error message and code:

```c++
Status(<grpc error code>, <error message>);
```

example:

```c++
Status(StatusCode::INVALID_ARGUMENT, "Ouch!");
```

### Client

To handle the error, check `error_code` and `error_message` members of `grpc::Status`:

```c++
Status status = stub_->GRPCMethod(&context, request, &response);
status.error_message();
status.error_code();
```

## C\#

Check the complete example [here](https://github.com/avinassh/grpc-errors/tree/master/csharp).

### Server

To send an error, raise `RpcException` with error message and code:

```c#
RpcException(new Status(<grpc error code>, <error message>));
```

Example:

```c#
throw new RpcException(new Status(StatusCode.InvalidArgument, "Ouch!"));
```

### Client

To handle the error, catch `RpcException` and access its member `Status`:

```c#
catch (RpcException e){
    e.Status.Detail;
    e.Status.StatusCode;
}
```

## Go

Check the complete example [here](https://github.com/avinassh/grpc-errors/tree/master/go).

### Server

To send an error, return `status.Errorf` with error message and code:

```go
status.Errorf(<grpc error code>, <error message>)
```

Example:

```go
return status.Errorf(codes.InvalidArgument, "Ouch!")
```

### Client

To handle the error, check `error` returned from gRPC call:

```go
_, err := client.GRPCMethod(...)
statusCode := status.FromError(err)
```

## Node

Check the complete example [here](https://github.com/avinassh/grpc-errors/tree/master/node).

### Server

To send an error, return with `code` and `message`:

```js
return callback({
    code: <grpc error code>,
    message: <error message>,
});
```

Example:

```js
return callback({
    code: grpc.status.INVALID_ARGUMENT,
    message: "Ouch!",
});
```

### Client

To handle the error, check `error` returned from gRPC call:

```js
client.grpcMethod({...}, function(err, response) {
    err.message;
    err.code;
});
```

## Objective C

Check the complete example [here](https://github.com/avinassh/grpc-errors/tree/master/objective-c).

### Client

To handle the error, check `error` returned from gRPC call:

```obj-c
[client grpcMethod:request handler:^(..., NSError *error) {
    error.localizedDescription;
    error.code;
}];
```

## Python

Check the complete example [here](https://github.com/avinassh/grpc-errors/tree/master/python).

### Server

To send an error, set `code` and `details` for `context` object:

```python
context.set_code(<grpc error code>)
context.set_details(<error message>)
```

Example:

```python
def GRPCMethod(self, request, context):
    context.set_details("Ouch!")
    context.set_code(grpc.StatusCode.INVALID_ARGUMENT)
    return response
```

### Client

To handle the error, catch `grpc.RpcError` exception:

```python
try:
    ...
except grpc.RpcError as e:
    e.details()
    status_code = e.code()
    status_code.name
    status_code.value
```

## Ruby

Check the complete example [here](https://github.com/avinassh/grpc-errors/tree/master/ruby).

### Server

To send an error, raise `GRPC::BadStatus` exception with `code` and `message` details:

```ruby
GRPC::BadStatus.new(<grpc error code>, <error message>)
```

Example:

```ruby
raise GRPC::BadStatus.new(GRPC::Core::StatusCodes::INVALID_ARGUMENT, "Ouch!")
```

### Client

To handle the error, catch `GRPC::BadStatus` exception:

```ruby
begin
  ...
rescue GRPC::BadStatus => e
  e.details
  e.code
end
```

## Swift

Check the complete example [here](https://github.com/avinassh/grpc-errors/tree/master/swift).

### Client

To handle the error, check `error` returned from gRPC call:

```swift
client.grpcMethod(request, handler: { (..., error: NSError?) in
    error.localizedDescription;
    error.code;
})
```

## Scala

Check the complete example [here](https://github.com/avinassh/grpc-errors/tree/master/scala). The example assumes you are using [ScalaPB](https://scalapb.github.io/) which uses grpc-java under the hood but has various conveniences suitable for programming in Scala.

### Server

If in a unary call, you simply use the regular `Future` constructs to denote success and failure. In the case of failures, the best practice is to use the static methods on the `Status` class from the `io.grpc` package and convert that to a `io.grpc.StatusRuntimeException`. According to the documentation, gRPC stubs prefer `StatusRuntimeException` to `StatusException`. 

```scala
Status
    .<grpc error code>
    .augmentDescription(<error message>)
    .asRuntimeException()
```

Example:

```scala
def GRPCMethod(request: Request): Future[Response] = {
Future.failed(
    Status
        .<grpc error code>
        .augmentDescription(<error message>)
        .asRuntimeException()
    )
}
```

### Client

To handle the error, if using a blocking stub, you can use any of Scala's standard mechanisms to catch the `Throwable`. Be careful because `StatusException` and `StatusRuntimeException` are Java classes that do not have a common ancestor other than `Exception`. If using the async stub again use the standard constructs provided by Scala Futures.

```scala
client.grpcMethod(...) onFailure {
    case ex: StatusRuntimeException =>
        val desc = ex.getStatus.getDescription
        val code = ex.getStatus.getCode
}
```

## Rust

Check the complete example
[here](https://github.com/avinassh/grpc-errors/tree/master/rust). The example
assumes we are using [grpcio](https://docs.rs/grpcio/0.4.2/grpcio/).

### Server

[grpcio](https://docs.rs/grpcio/0.4.2/grpcio/) uses
[`futures::sink::Sink`](https://rust-lang-nursery.github.io/futures-api-docs/0.3.0-alpha.12/futures/sink/trait.Sink.html)
to send values asynchronously.

To send an error simply call the
[`fail`](https://docs.rs/grpcio/0.4.2/grpcio/struct.UnarySink.html#method.fail)
method on the _sink_ with an instance of [`grpcio::RpcStatus`](https://docs.rs/grpcio/0.4.2/grpcio/struct.RpcStatus.html).

Example:

```rust
let future = sink
    .fail(RpcStatus::new(
        RpcStatusCode::InvalidArgument,
        Some("Ouch!".to_owned()),
    ));
```

### Client

To handle the error, check the
[`Result`](https://docs.rs/grpcio/0.4.2/grpcio/type.Result.html) returned by
the method
[call](https://docs.rs/grpcio/0.4.2/grpcio/struct.Client.html#method.unary_call)
for an [`grpcio::Error`](https://docs.rs/grpcio/0.4.2/grpcio/enum.Error.html).

```rust
let reply = client.GRPCMethod(&request);

match reply {
    Err(Error::RpcFailure(e)) => {
        assert_eq!(e.status, RpcStatusCode::InvalidArgument);
        assert_eq!(e.details, Some("Ouch!".to_owned()));
    },
    Ok(reply) => {
        // ...
    }
}
```

