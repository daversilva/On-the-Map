//
//  UdacityConvenience.swift
//  On the Map
//
//  Created by David Rodrigues on 22/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

extension UdacityClient {
    
    // MARK: POST Convenience Methods
    
    func login(_ jsonBody: String, completionHandlerForSession: @escaping (_ success: Bool, _ errorString: String?) -> Void)  {
        
        let _ = taskForPOSTMethod(jsonBody: jsonBody) { (results, error) in
            guard (error == nil) else {
                print(error!)
                completionHandlerForSession(false, error?.localizedDescription)
                return
            }
            
            guard let session = results![UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject],
                  let sessionId = session[UdacityClient.JSONResponseKeys.ID] as? String else {
                completionHandlerForSession(false, "Could not find session in \(String(describing: results))")
                return
            }
            
            guard let account = results![UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject],
                  let userKey = account[UdacityClient.JSONResponseKeys.Key] as? String else {
                completionHandlerForSession(false, "Could not find account in \(String(describing: results))")
                return
            }

            self.sessionID = sessionId
            self.userID = userKey
            
            self.getPublicUserData(completionHandler: { (success, error) in
                if success {
                    completionHandlerForSession(true, nil)
                } else {
                    completionHandlerForSession(false, error)
                }
            })

        }
    }
    
    func loginWithCredentials(_ credentials: UdacityCredential, completionHandlerForSession: @escaping (_ success: Bool, _ errorString: String?) -> Void)  {
        
        let jsonBody = "{\"\(UdacityClient.JSONBody.Key.Udacity)\": {\"\(UdacityClient.JSONBody.Key.UserName)\": \"\(credentials.username)\", \"\(UdacityClient.JSONBody.Key.Password)\": \"\(credentials.password)\"}}"
        login(jsonBody, completionHandlerForSession: completionHandlerForSession)
    }
    
    func loginWithFacebook(_ accessToken: String, completionHandlerForSession: @escaping (_ success: Bool, _ errorString: String?) -> Void)  {
        
        let jsonBody = "{\"\(UdacityClient.JSONBody.Key.Facebook)\": {\"\(UdacityClient.JSONBody.Key.AccessToken)\": \"\(accessToken);\"}}"
        login(jsonBody, completionHandlerForSession: completionHandlerForSession)
    }
    
    func logoutSessionFacebook(completionHandlerForDELETESession: @escaping (_ success: Bool, _ error: String?) -> Void)  {
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        completionHandlerForDELETESession(true, nil)
    }
    
    func getPublicUserData(completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let _ = taskForGETMethod { (results, error) in
            guard (error == nil) else {
                print(error!)
                completionHandler(false, error?.localizedDescription)
                return
            }
            
            guard let user = results![UdacityClient.JSONResponseKeys.User] as? [String:AnyObject] else {
                completionHandler(false, "Could not find user in \(String(describing: results))")
                return
            }
            
            if let firstName = user[UdacityClient.JSONResponseKeys.FirstName] as? String {
                self.firstName = firstName
            } else {
                self.firstName = "First-Name"
            }
            
            if let lastName = user[UdacityClient.JSONResponseKeys.LastName] as? String {
                self.lastName = lastName
            } else {
                self.lastName = "Last-Name"
            }
            
            completionHandler(true, nil)
        }
    }
}
