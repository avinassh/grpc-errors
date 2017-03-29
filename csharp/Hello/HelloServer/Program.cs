using System;
using System.Threading.Tasks;
using Grpc.Core;
using Hello;

namespace HelloServer
{
	class HelloServerImpl : HelloService.HelloServiceBase
	{
		// Server side handler of the SayHello RPC
		public override Task<HelloResp> SayHello(HelloReq request, ServerCallContext context)
		{
			return Task.FromResult(new HelloResp { Result = "Hello " + request.Name });
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


			Console.WriteLine("Greeter server listening on port " + Port);
			Console.WriteLine("Press any key to stop the server...");
			Console.ReadKey();

			server.ShutdownAsync().Wait();
		}
	}
}
