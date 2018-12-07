//
//  URLSession.swift
//  Powerups
//
//  Created by Sean Orelli on 12/5/18.
//  Copyright © 2018 Sean Orelli. All rights reserved.
//

import UIKit

typealias ResponseClosure = (Data, HTTPURLResponse, Error?) -> Void

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case head = "HEAD"
    case delete = "DELETE"
    //UPLOAD?
    //DOWNLOAD?
}

/*________________________________________________________________________________________________
 
                                            URLSession
 ________________________________________________________________________________________________*/
extension URLSession {
    
    static var current: URLSession?
    static var baseURLString: String?
    static var token: String?
    
    func urlRequest(urlString: String, method: HTTPMethod, parameters: [String: String]?=nil, body: String?=nil) -> URLRequest? {
        var urlPath = urlString
        if method == .get {
            if let params = parameters?.httpParameterString{
                urlPath = urlString + "?\(params)"
            }
        }
        
        if let url =  URL(string: urlPath){
            var request = URLRequest(url: url)
            if let token = URLSession.token {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue(token, forHTTPHeaderField: "Authorization")
            }
            
            request.httpMethod = method.rawValue
            
            if method == .post {
                if let parameters = parameters {
                    let body = parameters.httpParameterString
                    request.httpBody = body.data(using: .utf8)
                }
                if let body = body {
                    request.httpBody = body.data(using: .utf8)
                }
            }
            
            
            
            return request
        }
        return nil
    }
    
    
    func get(urlString: String, parameters: [String: String]?=nil, completion: ResponseClosure?=nil) {
        
        if let request = urlRequest(urlString: urlString, method: .get, parameters: parameters){
            
            let dataTask = self.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    print("ERROR:")
                    print(error)
                } else if data != nil, let response = response as? HTTPURLResponse, response.statusCode == 200 || response.statusCode == 201 {
                    print("SUCCESS")
                    if let completion = completion {
                        completion(data!, response, error)
                    }
                }
                
            }
            dataTask.resume()
        }
        
    }
    
    func post(urlString: String, parameters: [String: String]?=nil, body: String?=nil, completion: ResponseClosure?=nil) {
        if let request = urlRequest(urlString: urlString, method: .post,
                                    parameters: parameters, body: body){
            let dataTask = self.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    print("ERROR:")
                    print(error)
                } else if data != nil, let response = response as? HTTPURLResponse, response.statusCode == 200 || response.statusCode == 201 {
                    print("SUCCESS")
                    if let completion = completion {
                        completion(data!, response, error)
                    }
                }
            }
            dataTask.resume()
        }
        
    }
    
    
    func authenticate(urlString: String, parameters: [String: String]?=nil, completion: ResponseClosure?=nil) {
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpMethod = "POST"
        if let parameters = parameters {
            let body = parameters.httpParameterString
            request.httpBody = body.data(using: .utf8)
        }
        
        let dataTask = self.dataTask(with: request) { data, response, error in
            if let d = data {
                let s = String(data: d, encoding: .utf8)
                print(s ?? "")
            }
            
            if let error = error {
                print("ERROR:")
                print(error)
            } else if data != nil, let response = response as? HTTPURLResponse, response.statusCode == 200 || response.statusCode == 201 {
                
                
                print("SUCCESS")
                if let completion = completion {
                    completion(data!, response, error)
                }
                
            }
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
        }
        dataTask.resume()
    }
    
    func put(urlString: String, parameters: [String: String]?=nil, completion: ResponseClosure?=nil) {
        
    }
    
    func delete(urlString: String, parameters: [String: String]?=nil, completion: ResponseClosure?=nil) {
        
    }
    
    func head(urlString: String, parameters: [String: String]?=nil, completion: ResponseClosure?=nil) {
        
    }
    
    func upload(urlString: String, parameters: [String: String]?=nil, data: Data, progress:Closure?=nil, completion: ResponseClosure?=nil) {
        
    }
    
    func download(urlString: String, parameters: [String: String]?=nil, progress:Closure? = nil, completion: ResponseClosure?=nil) {
        
    }
}
