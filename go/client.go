package main

import (
	"fmt"
	"log"

	"golang.org/x/net/context"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	api "github.com/avinassh/grpc-errors/go/hello"
)

func main() {
	conn, err := grpc.Dial("localhost:50051", grpc.WithInsecure())
	if err != nil {
		log.Fatalf("Did not connect: %v", err)
	}
	defer conn.Close()
	c := api.NewHelloServiceClient(conn)

	// ideally, you should handle error here too, for brevity
	// I am ignoring that
	resp, _ := c.SayHello(
		context.Background(),
		&api.HelloReq{Name: "Euler"},
	)
	fmt.Println(resp.GetResult())

	resp, err = c.SayHelloStrict(
		context.Background(),
		&api.HelloReq{Name: "Leonhard Euler"},
	)

	if err != nil {
		// ouch!
		// lets print the gRPC error message
		// which is "Length of `Name` cannot be more than 10 characters"
		errStatus, _ := status.FromError(err)
		fmt.Println(errStatus.Message())
		// lets print the error code which is `INVALID_ARGUMENT`
		fmt.Println(errStatus.Code())
		// Want its int version for some reason?
		// you shouldn't actullay do this, but if you need for debugging,
		// you can do `int(status_code)` which will give you `3`
		//
		// Want to take specific action based on specific error?
		if codes.InvalidArgument == errStatus.Code() {
			// do your stuff here
			log.Fatal()
		}
	}

	fmt.Println(resp.GetResult())
}
