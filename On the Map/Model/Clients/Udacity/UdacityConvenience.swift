//
//  UdacityConvenience.swift
//  On the Map
//
//  Created by David Rodrigues on 22/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit
import Foundation

extension UdacityClient {
    
    // MARK: POST Convenience Methods
    
    func login(_ jsonBody: String, completionHandlerForSession: @escaping (_ success: Bool, _ errorString: String?) -> Void)  {
        
        let _ = taskForPOSTMethod(jsonBody: jsonBody) { (results, error) in
            guard (error == nil) else {
                print(error!)
                completionHandlerForSession(false, error?.localizedDescription)
                return
            }
            
            guard let account = results![UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject],
                let sessionId = account[UdacityClient.JSONResponseKeys.ID] as? String else {
                    print("Could not find account or sessionId in \(String(describing: results))")
                    return
            }
            
            self.sessionID = sessionId
            completionHandlerForSession(true, nil)
        }
    }
    
    func loginWithCredentials(_ credentials: StudentCredential, completionHandlerForSession: @escaping (_ success: Bool, _ errorString: String?) -> Void)  {
        
        let jsonBody = "{\"\(UdacityClient.JSONBodyKeys.Udacity)\": {\"\(UdacityClient.JSONBodyKeys.UserName)\": \"\(credentials.username)\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"\(credentials.password)\"}}"
        
        login(jsonBody, completionHandlerForSession: completionHandlerForSession)
    }
    
    func loginWithFacebook(_ accessToken: String, completionHandlerForSession: @escaping (_ success: Bool, _ errorString: String?) -> Void)  {
        
        let jsonBody = "{\"\(UdacityClient.JSONBodyKeys.Facebook)\": {\"\(UdacityClient.JSONBodyKeys.AccessToken)\": \"\(accessToken);\"}}"
        print(jsonBody)
        login(jsonBody, completionHandlerForSession: completionHandlerForSession)
        
    }
    
}
