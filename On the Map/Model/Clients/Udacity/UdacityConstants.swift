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
        static let ApiSession = "/api/session"
        static let ApiUsers = "/api/users/"
    }
    
    // MARK: Methods
    struct Methods {
        static let Post = "POST"
        static let Delete = "DELETE"
        static let Get = "GET"
    }
    
    // MARK: JSON Body Keys
    struct JSONBody {

        struct Key {
            static let Udacity = "udacity"
            static let UserName = "username"
            static let Password = "password"
            static let Facebook = "facebook_mobile"
            static let AccessToken = "access_token"
            static let Accept = "Accept"
            static let ContentType = "Content-Type"
        }
        
        struct Value {
            static let ApplicationJson = "application/json"
        }
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
        
        // MARK: User
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }
    
    // MARK: Messages
    struct Messages {
        
        static let OnTheMap = "On The Map"
        static let Dismiss = "Dismiss"
        static let EmailOrPasswordEmpty = "Email or Password Empty."
        static let EmailOrPasswordWrong = "Email or Password Wrong."
        static let NoConnection = "No Networking in your Device."
        static let LoginError = "Login Error"
        static let TokenError = "Token Error"
        static let FacebookError = "Facebook can't connect to server."
    }
    
    struct XSRF {
        static let CookieName = "XSRF-TOKEN"
        static let HttpHeader = "X-XSRF-TOKEN"
    }
    
}
