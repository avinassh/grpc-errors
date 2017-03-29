using System;
using System.Threading.Tasks;
using Grpc.Core;
using Hello;

namespace HelloServer
{
	class HelloServerImpl : HelloService.HelloServiceBase
	{
		public override Task<HelloResp> SayHello(HelloReq request, ServerCallContext context)
		{
			return Task.FromResult(new HelloResp { Result = "Hey, " + request.Name + "!"});
		}

		public override Task<HelloResp> SayHelloStrict(HelloReq request, ServerCallContext context)
		{
			if (request.Name.Length >= 10) {
				const string msg = "Length of `Name` cannot be more than 10 characters";
				throw new RpcException(new Status(StatusCode.InvalidArgument, msg));	
			}
			return Task.FromResult(new HelloResp { Result = "Hey, " + request.Name + "!"});
		}
	}

	class Program
	{
		const int Port = 50051;

		public static void Main(string[] args)
		{

			Server server = new Server
			{
				Services = { HelloService.BindService(new HelloServerImpl()) },
				Ports = { new ServerPort("localhost", Port, ServerCredentials.Insecure) }
			};

			server.Start();

			Console.WriteLine("Hello server listening on port " + Port);
			Console.WriteLine("Press any key to stop the server...");
			Console.ReadKey();

			server.ShutdownAsync().Wait();
		}
	}
}
