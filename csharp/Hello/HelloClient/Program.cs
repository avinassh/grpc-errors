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
			// ideally you should check for errors here too
			var reply = client.SayHello(new HelloReq { Name = "Euler" });
			Console.WriteLine(reply.Result);

			try
			{
				reply = client.SayHelloStrict(new HelloReq { Name = "Leonhard Euler" });
				Console.WriteLine(reply.Result);
			}
			catch (RpcException e)
			{
				// ouch!
				// lets print the gRPC error message
				// which is "Length of `Name` cannot be more than 10 characters"
				Console.WriteLine(e.Status.Detail);
				// lets access the error code, which is `INVALID_ARGUMENT`
				Console.WriteLine(e.Status.StatusCode);
				// Want its int version for some reason?
				// you shouldn't actually do this, but if you need for debugging,
				// you can access `e.Status.StatusCode` which will give you `3`
				Console.WriteLine((int)e.Status.StatusCode);
				// Want to take specific action based on specific error?
				if (e.Status.StatusCode == Grpc.Core.StatusCode.InvalidArgument) {
					// do your thing
				}
			}

			channel.ShutdownAsync().Wait();
			Console.WriteLine("Press any key to exit...");
			Console.ReadKey();
		}
	}
}
