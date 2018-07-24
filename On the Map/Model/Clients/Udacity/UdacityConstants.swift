//
//  UdacityConstants.swift
//  On the Map
//
//  Created by David Rodrigues on 21/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let AccountSignUpURL = "https://auth.udacity.com/sign-up"
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api/session"
    }
    
    // MARK: Methods
    struct Methods {
        static let Post = "POST"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let UserName = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Account
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        
        // MARK: Session
        static let Session = "session"
        static let ID = "id"
        static let Expiration = "expiration"
    }
    
    // MARK: Messages
    struct Messages {
        
        static let OnTheMap = "On The Map"
        static let Dismiss = "Dismiss"
        static let EmailOrPasswordEmpty = "Email or Password Empty."
        static let EmailOrPasswordWrong = "Email or Password Wrong."
        static let NoConnection = "No Networking in your Device."
    }
}
