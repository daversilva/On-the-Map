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
    
    func loginWithCredentials(_ credentials: StudentCredential, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) -> Void)  {
        
        let jsonBody = "{\"\(UdacityClient.JSONBodyKeys.Udacity)\": {\"\(UdacityClient.JSONBodyKeys.UserName)\": \"\(credentials.username)\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"\(credentials.password)\"}}"
        
        let _ = taskForPOSTMethod(jsonBody: jsonBody) { (results, error) in
            guard (error == nil) else {
                print(error!)
                completionHandlerForSession(false, nil, error?.localizedDescription)
                return
            }
            
            guard let account = results![UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject],
                let sessionId = account[UdacityClient.JSONResponseKeys.ID] as? String else {
                    print("Could not find account or sessionId in \(String(describing: results))")
                return
            }
            
            self.sessionID = sessionId
            completionHandlerForSession(true, sessionId, nil)
        }
    }

}
