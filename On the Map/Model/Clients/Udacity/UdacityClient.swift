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
    var userID: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGETMethod(completionHandlerForGet: @escaping (_ result: [String:AnyObject]?,_ error: NSError?) -> Void) {
        
        guard let userKey = userID else {
            self.sendError("Can not find User Key", "completionHandlerForStudentInformation", completionHandler: completionHandlerForGet)
            return
        }
        
        let request = NSMutableURLRequest(url: udacityURLWithoutParameters(UdacityClient.Constants.ApiUsers + userKey))
        request.httpMethod = UdacityClient.Methods.Get
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard (error == nil) else {
                print(error?.localizedDescription ?? "Error on request")
                self.sendError("Error on request: \(String(describing: error))", "completionHandlerForStudentInformation", completionHandler: completionHandlerForGet)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                self.sendError("Status code other than 2xx!: \(String(describing: error))", "completionHandlerForStudentInformation", completionHandler: completionHandlerForGet)
                return
            }
            
            guard let data = data else {
                self.sendError("No data was returned by the request!: \(String(describing: error))", "completionHandlerForStudentInformation", completionHandler: completionHandlerForGet)
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGet)
        }
        
        task.resume()
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(jsonBody: String, completionHandlerForPOST: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: udacityURLWithoutParameters())
        request.httpMethod = UdacityClient.Methods.Post
        request.addValue(UdacityClient.JSONBody.Value.ApplicationJson, forHTTPHeaderField: UdacityClient.JSONBody.Key.Accept)
        request.addValue(UdacityClient.JSONBody.Value.ApplicationJson, forHTTPHeaderField: UdacityClient.JSONBody.Key.ContentType)
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else {
                self.sendError("There was an error with your request: \(String(describing: error))", "taskForPOSTMethod", completionHandler: completionHandlerForPOST)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                self.sendError("Your request returned a status code other than 2xx!", "taskForPOSTMethod", completionHandler: completionHandlerForPOST)
                return
            }
            
            guard let data = data else {
                self.sendError("No data was returned by the request!", "taskForPOSTMethod", completionHandler: completionHandlerForPOST)
                return
            }

            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: DELETE
    
    func logoutSessionUdacity(completionHandlerForDELETESession: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: udacityURLWithoutParameters())
        request.httpMethod = UdacityClient.Methods.Delete
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == UdacityClient.XSRF.CookieName { xsrfCookie = cookie}
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: UdacityClient.XSRF.HttpHeader)
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if error != nil {
                completionHandlerForDELETESession(false, "Error with request: \(String(describing: error?.localizedDescription))")
                return
            } else {
                completionHandlerForDELETESession(true, nil)
            }
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
        }
        
        task.resume()
    }
    
    // MARK: Helpers
    
    func sendError(_ error: String, _ method: String, completionHandler: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void) {
        print(error)
        let userInfo = [NSLocalizedDescriptionKey: error]
        completionHandler(nil, NSError(domain: method, code: 1, userInfo: userInfo))
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
        components.path = UdacityClient.Constants.ApiSession
        components.queryItems = [URLQueryItem]()
        
        for(key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    private func udacityURLWithoutParameters(_ path: String = UdacityClient.Constants.ApiSession) -> URL {
        var components = URLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = path
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
