using System;
using Grpc.Core;
using Hello;

namespace HelloClient
{
	class Program
	{
		public static void Main(string[] args)
		{
			Channel channel = new Channel("127.0.0.1:50051", ChannelCredentials.Insecure);

			var client = new HelloService.HelloServiceClient(channel);
			String user = "Euler";

			var reply = client.SayHello(new HelloReq { Name = user });
			Console.WriteLine(reply.Result);

			channel.ShutdownAsync().Wait();
			Console.WriteLine("Press any key to exit...");
			Console.ReadKey();
		}
	}
}
