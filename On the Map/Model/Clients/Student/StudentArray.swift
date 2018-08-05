//
//  StudentArray.swift
//  On the Map
//
//  Created by David Rodrigues on 05/08/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import Foundation

class StudentArray {
    
    var studentLocations = [StudentLocation]()
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> StudentArray {
        struct Singleton {
            static var sharedInstance = StudentArray()
        }
        return Singleton.sharedInstance
    }
}
