//
//  StudentConstants.swift
//  On the Map
//
//  Created by David Rodrigues on 27/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import Foundation

extension StudentClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"
    }
    
    // MARK: Methods
    struct Methods {
        static let Get = "GET"
        static let Post = "POST"
    }
    
    // MARK: Parse API
    
    struct ParseApi {
        
        struct Key {
            static let XParseApplicationId = "X-Parse-Application-Id"
            static let XParseRestApiKey = "X-Parse-REST-API-Key"
        }
        
        struct Value {
            static let ParseApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
            static let ParseRestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        }
        
        struct QueryItems {
            
            struct Key {
                static let Limit = "limit"
                static let Order = "order"
            }
            
            struct Value {
                static let Limit = "100"
                static let Order = "-updateAt"
            }
        }
    }
    
    // MARK: JSON Keys
    struct JSONKeys {
        static let Result = "results"
        
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MediaURL = "mediaURL"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
    }
    
    // MARK: JSONBody
    
    struct JSONBody {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaUrl = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    struct Messages {
        static let NotPossibleDownloadStudents = "It was not possible download the students!"
        static let NotPossibleDisplayLocation = "It was not possible display to Location!"
        static let NotPossibleDisplayStudents = "It was not possible to display the students!"
        static let UnablePostLocation = "Unable to post to Location"
        static let CompleteFields = "Complete all fields"
        static let LocationNotFound = "Location not found"
    }
    
}
