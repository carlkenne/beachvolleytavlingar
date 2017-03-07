//
//  HttpDownloader.swift
//  SandSports
//
//  Created by Carl Kenne on 27/05/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

class HttpDownloader{
    
    func httpPost(_ request1: String, bodyData: String, callback: @escaping (Data?, String?) -> Void){

        var request = URLRequest(url: URL(string: request1)!)
        request.httpMethod = "POST"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            DispatchQueue.main.async {
                if error != nil {
                    callback(nil, error!.localizedDescription)
                } else {
                    
                    callback(data, nil)
                }
            }
        }.resume()
    }
    
    func httpGetOld(_ request1: String, callback: @escaping (Data?, String?) -> Void) {
        if(request1 == "") {
            callback(nil, "empty request")
            return
        }
        var request = URLRequest(url: URL(string: request1)!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) {data, response, err in
            DispatchQueue.main.async {
                if err != nil {
                    callback(nil, err!.localizedDescription)
                } else {
                    callback(data, nil)
                }
            }
        }.resume()
    }
}
