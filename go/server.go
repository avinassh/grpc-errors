package main

import (
	"fmt"
	"log"
	"net"

	"golang.org/x/net/context"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	api "github.com/avinassh/grpc-errors/go/hello"
)

type HelloServer struct{}

func (s *HelloServer) SayHello(ctx context.Context, req *api.HelloReq) (*api.HelloResp, error) {
	return &api.HelloResp{Result: fmt.Sprintf("Hey, %s!", req.GetName())}, nil
}

func (s *HelloServer) SayHelloStrict(ctx context.Context, req *api.HelloReq) (*api.HelloResp, error) {
	if len(req.GetName()) >= 10 {
		return nil, status.Errorf(codes.InvalidArgument,
			"Length of `Name` cannot be more than 10 characters")
	}

	return &api.HelloResp{Result: fmt.Sprintf("Hey, %s!", req.GetName())}, nil
}

func Serve() {
	addr := fmt.Sprintf(":%d", 50051)
	conn, err := net.Listen("tcp", addr)
	if err != nil {
		log.Fatalf("Cannot listen to address %s", addr)
	}
	s := grpc.NewServer()
	api.RegisterHelloServiceServer(s, &HelloServer{})
	if err := s.Serve(conn); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}

func main() {
	Serve()
}
