//
//  StudentConvenience.swift
//  On the Map
//
//  Created by David Rodrigues on 27/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import Foundation

extension StudentClient {
    
    func loadStudents(completionHandlerForSession: @escaping (_ results: [StudentLocation], _ success: Bool, _ errorString: String?) -> Void)  {
        
        let parameters: [String:String] = [
            StudentClient.ParseApi.QueryItems.Key.Limit: StudentClient.ParseApi.QueryItems.Value.Limit
        ]
        
        let _ = taskForGetMethod(parameters) { (results, error) in
            guard (error == nil) else {
                print(error!)
                completionHandlerForSession([], false, error?.localizedDescription)
                return
            }
            
            print(results)
//            guard let result = results!["results"] as? [String:AnyObject] else {
//                print("Could not find results")
//                return
//            }
//            
//            print(result)
            
            completionHandlerForSession([], true, nil)
        }
        
    }
    
}
