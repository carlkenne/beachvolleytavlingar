//
//  HttpDownloader.swift
//  SandSports
//
//  Created by Carl Kenne on 27/05/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

class HttpDownloader{
    
    func httpPost(request1: String, bodyData: String, callback: (NSData?, String?) -> Void){
        
        var request = NSMutableURLRequest(URL: NSURL(string: request1)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                if error != nil {
                    callback(nil, error.localizedDescription)
                } else {
                    
                    callback(data, nil)
                }
            }
        })
    }

    
    func httpGetOld(request1: String, callback: (NSData?, String?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: request1)!)
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                if error != nil {
                    callback(nil, error.localizedDescription)
                } else {
                    callback(data, nil)
                }
            }
        })
    }
}