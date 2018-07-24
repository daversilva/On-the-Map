//
//  UdacityClient.swift
//  On the Map
//
//  Created by David Rodrigues on 21/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    // MARK: Properties
    
    // Shared Session
    var session = URLSession.shared
    
    // Authentication State
    var sessionID: String? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(jsonBody: String, completionHandlerForPOST: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: udacityURLWithoutParameters())
        request.httpMethod = UdacityClient.Methods.Post
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else {
                self.sendError("There was an error with your request: \(String(describing: error))", "taskForPOSTMethod", completionHandlerForPOST: completionHandlerForPOST)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                self.sendError("Your request returned a status code other than 2xx!", "taskForPOSTMethod", completionHandlerForPOST: completionHandlerForPOST)
                return
            }
            
            guard let data = data else {
                self.sendError("No data was returned by the request!", "taskForPOSTMethod", completionHandlerForPOST: completionHandlerForPOST)
                return
            }

            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    func sendError(_ error: String, _ method: String, completionHandlerForPOST: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void) {
        print(error)
        let userInfo = [NSLocalizedDescriptionKey: error]
        completionHandlerForPOST(nil, NSError(domain: method, code: 1, userInfo: userInfo))
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: [String:AnyObject]?, _ error: NSError?) -> Void) {
        var parsedResult: [String:AnyObject]!
        let range = Range(5..<data.count)
        let newData = data.subdata(in: range)
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: \(data)"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 0, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    private func udacityURLFromParameters(_ parameters: [String:AnyObject], withPathExtesion: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath
        components.queryItems = [URLQueryItem]()
        
        for(key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    private func udacityURLWithoutParameters() -> URL {
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath
        components.queryItems = [URLQueryItem]()

        return components.url!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
