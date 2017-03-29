#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import <GRPCClient/GRPCCall+ChannelArg.h>
#import <GRPCClient/GRPCCall+Tests.h>
#import <GRPC/Status.h>
#import <Hello/Hello.pbrpc.h>

static NSString * const kHostAddress = @"localhost:50051";


int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        [GRPCCall useInsecureConnectionsForHost:kHostAddress];
        [GRPCCall setUserAgentPrefix:@"HelloWorld/1.0" forHost:kHostAddress];
        
        HelloService *client = [[HelloService alloc] initWithHost:kHostAddress];
        
        HelloReq *request = [HelloReq message];
        request.name = @"Euler";
        
        // ideally you should check for errors here too
        [client sayHelloWithRequest:request handler:^(HelloResp *response, NSError *error) {
            NSLog(@"%@", response.result);
        }];
        
        // lets try the failing case
        request.name = @"Leonhard Euler";
        [client sayHelloStrictWithRequest:request handler:^(HelloResp *response, NSError *error) {
            
            if (error.code == GRPC_STATUS_OK) {
                NSLog(@"%@", response.result);
            } else {
                // ouch!
                // lets print the gRPC error message
                // which is "Length of `Name` cannot be more than 10 characters"
                NSLog(@"%@", error.localizedDescription);
                // Want its int version for some reason?
                // you shouldn't actually do this, but if you need for debugging,
                // you can access `error.code` which will give you `3`
                NSLog(@"%ld", (long)error.code);
                // Want to take specific action based on specific error?
                if (error.code == GRPC_STATUS_INVALID_ARGUMENT) {
                    // do your thing
                }
            }
        }];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
