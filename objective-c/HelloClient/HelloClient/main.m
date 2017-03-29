#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import <GRPCClient/GRPCCall+ChannelArg.h>
#import <GRPCClient/GRPCCall+Tests.h>
#import <Hello/Hello.pbrpc.h>

static NSString * const kHostAddress = @"localhost:50051";


int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        [GRPCCall useInsecureConnectionsForHost:kHostAddress];
        [GRPCCall setUserAgentPrefix:@"HelloWorld/1.0" forHost:kHostAddress];
        
        HelloService *client = [[HelloService alloc] initWithHost:kHostAddress];
        
        HelloReq *request = [HelloReq message];
        request.name = @"Euler";
        
        [client sayHelloWithRequest:request handler:^(HelloResp *response, NSError *error) {
            NSLog(@"%@", response.result);
        }];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
