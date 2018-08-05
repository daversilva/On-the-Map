//
//  StudentClient.swift
//  On the Map
//
//  Created by David Rodrigues on 27/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import Foundation

class StudentClient: NSObject {
    
    // MARK: Properties
    
    // Shared Session
    var session = URLSession.shared
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGetMethod(_ parameters: [String:String], completionHandlerForGet: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: studentURLFromParameters(parameters))
        request.httpMethod = StudentClient.Methods.Get
        request.addValue(StudentClient.ParseApi.Value.ParseApplicationId, forHTTPHeaderField: StudentClient.ParseApi.Key.XParseApplicationId)
        request.addValue(StudentClient.ParseApi.Value.ParseRestApiKey, forHTTPHeaderField: StudentClient.ParseApi.Key.XParseRestApiKey)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else {
                self.sendError("There was an error with your request: \(String(describing: error))", "taskForGetMethod", completionHandlerForGet: completionHandlerForGet)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                self.sendError("Your request returned a status code other than 2xx!", "taskForGetMethod", completionHandlerForGet: completionHandlerForGet)
                return
            }
            
            guard let data = data else {
                self.sendError("No data was returned by the request!", "taskForGetMethod", completionHandlerForGet: completionHandlerForGet)
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGet)
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPostMethod(jsonBody: String, completionHandlerForPost: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: studentURLWithoutParameters())
        request.httpMethod = StudentClient.Methods.Post
        request.addValue(StudentClient.ParseApi.Value.ParseApplicationId, forHTTPHeaderField: StudentClient.ParseApi.Key.XParseApplicationId)
        request.addValue(StudentClient.ParseApi.Value.ParseRestApiKey, forHTTPHeaderField: StudentClient.ParseApi.Key.XParseRestApiKey)
        request.addValue(UdacityClient.JSONBody.Value.ApplicationJson, forHTTPHeaderField: UdacityClient.JSONBody.Key.ContentType)
        request.httpBody = jsonBody.data(using: .utf8)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else {
                completionHandlerForPost(false, "There was an error with your post")
                return
            }
            
            if let data = data {
                print(data)
                completionHandlerForPost(true, nil)
            } else {
                completionHandlerForPost(false, "There was an error with your post")
            }
        }
        
        task.resume()
    }
    
    // MARK: Helpers
    
    func sendError(_ error: String, _ method: String, completionHandlerForGet: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void) {
        print(error)
        let userInfo = [NSLocalizedDescriptionKey: error]
        completionHandlerForGet(nil, NSError(domain: method, code: 1, userInfo: userInfo))
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: [String:AnyObject]?, _ error: NSError?) -> Void) {
        var parsedResult: [String:AnyObject]!
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: \(data)"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 0, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    private func studentURLWithoutParameters() -> URL {
        var components = URLComponents()
        components.scheme = StudentClient.Constants.ApiScheme
        components.host = StudentClient.Constants.ApiHost
        components.path = StudentClient.Constants.ApiPath
        components.queryItems = [URLQueryItem]()
        
        return components.url!
    }
    
    private func studentURLFromParameters(_ parameters: [String:String], withPathExtesion: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = StudentClient.Constants.ApiScheme
        components.host = StudentClient.Constants.ApiHost
        components.path = StudentClient.Constants.ApiPath
        components.queryItems = [URLQueryItem]()
        
        for(key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> StudentClient {
        struct Singleton {
            static var sharedInstance = StudentClient()
        }
        return Singleton.sharedInstance
    }
}
