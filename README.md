# gRPC Errors

gRPC is an amazing library, however, the documentation lacks details on error handling. The code examples do not contain error handling part either (though few does seem to have them). Some test suits in main repo do have them, but it might be difficult to figure out for a beginner.

This project is my attempt to fix the issue. The [repository](https://github.com/avinassh/grpc-errors) contains examples in all popular languages and contain similar implementations of server and client across languages and also, error handling. So you can run server in one language of your choice and client in another, error handling still works seamlessly. The rest of this page shows how to send errors from server, handle them in client, in different languages.

## CPP

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

## CSharp

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

To send an error, return `grpc.Errorf` with error message and code:

    ```go
    grpc.Errorf(<grpc error code>, <error message>)
    ```

Example:

    ```go
    return grpc.Errorf(codes.InvalidArgument, "Ouch!")
    ```

### Client

To handle the error, check `error` returned from gRPC call:

    ```go
    _, err := client.GRPCMethod(...)
    status_code := grpc.Code(err)
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
