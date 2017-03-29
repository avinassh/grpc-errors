import UIKit
import GRPCClient
import Hello
import grpc

let kHostAddress = "localhost:50051"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        GRPCCall.useInsecureConnectionsForHost(kHostAddress)
        GRPCCall.setUserAgentPrefix("HelloWorld/1.0", forHost: kHostAddress)
        let client = HelloService(host: kHostAddress)
        let request = HelloReq()
        
        request.name = "Euler"
        client.sayHelloWithRequest(request, handler: {(response: HelloResp?, error: NSError?) in
            // ideally you should check for errors here too
            print(response!.result)
        })
        
        // lets try the failing case
        request.name = "Leonhard Euler"
        client.sayHelloStrictWithRequest(request, handler: { (response: HelloResp?, error: NSError?) in
            if let response = response {
                print(response.result)
            } else {
                // ouch!
                // lets print the gRPC error message
                // which is "Length of `Name` cannot be more than 10 characters"
                let error = error!
                print(error.localizedDescription)
                // Want its int version for some reason?
                // you shouldn't actually do this, but if you need for debugging,
                // you can access `error.code` which will give you `3`
                print(error.code)
                // Want to take specific action based on specific error?
                if (Int32(error.code) == GRPC_STATUS_INVALID_ARGUMENT.rawValue) {
                    // do your thing
                }
            }
        })
    }
}

