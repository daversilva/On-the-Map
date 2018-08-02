//
//  Student.swift
//  On the Map
//
//  Created by David Rodrigues on 27/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    let createdAt: String
    let updatedAt: String
    
    init(parse: [String:AnyObject]) {
        if let objectId = parse[StudentClient.JSONKeys.ObjectId] as? String {
            self.objectId = objectId
        } else {
            self.objectId = ""
        }
        
        if let uniqueKey = parse[StudentClient.JSONKeys.UniqueKey] as? String {
            self.uniqueKey = uniqueKey
        } else {
            self.uniqueKey = ""
        }
        
        if let firstName = parse[StudentClient.JSONKeys.FirstName] as? String {
            self.firstName = firstName
        } else {
            self.firstName = ""
        }
        
        if let lastName = parse[StudentClient.JSONKeys.LastName] as? String {
            self.lastName = lastName
        } else {
            self.lastName = ""
        }
        
        if let mapString = parse[StudentClient.JSONKeys.MapString] as? String {
            self.mapString = mapString
        } else {
            self.mapString = ""
        }
        
        if let mediaUrl = parse[StudentClient.JSONKeys.MediaURL] as? String {
            self.mediaURL = mediaUrl
        } else {
            self.mediaURL = ""
        }
        
        if let latitude = parse[StudentClient.JSONKeys.Latitude] as? Double {
            self.latitude = latitude
        } else {
            self.latitude = 0.0
        }
        
        if let longitude = parse[StudentClient.JSONKeys.Longitude] as? Double {
            self.longitude = longitude
        } else {
            self.longitude = 0.0
        }
        
        if let createdAt = parse[StudentClient.JSONKeys.CreatedAt] as? String {
            self.createdAt = createdAt
        } else {
            self.createdAt = ""
        }
        
        if let updatedAt = parse[StudentClient.JSONKeys.UpdatedAt] as? String {
            self.updatedAt = updatedAt
        } else {
            self.updatedAt = ""
        }
    }

}
