//
//  ViewController.swift
//  HelloClient
//
//  Created by avi on 29/03/17.
//  Copyright © 2017 avi.im. All rights reserved.
//

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
            print("\(response!.result)")
        })
    }
}

