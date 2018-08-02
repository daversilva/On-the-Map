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
            StudentClient.ParseApi.QueryItems.Key.Limit: StudentClient.ParseApi.QueryItems.Value.Limit,
            StudentClient.ParseApi.QueryItems.Key.Order: StudentClient.ParseApi.QueryItems.Value.Order
        ]
        
        let _ = taskForGetMethod(parameters) { (results, error) in
            guard (error == nil) else {
                print(error!)
                completionHandlerForSession([], false, error?.localizedDescription)
                return
            }
            
            guard let result = results![StudentClient.JSONKeys.Result] as? [[String:AnyObject]] else {
                completionHandlerForSession([], false, "Could not parse result json into StudentClient")
                return
            }
            
            let students = self.parseJsonToStudent(result)
            
            completionHandlerForSession(students, true, nil)
        }
        
    }
    
    private func parseJsonToStudent(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        
        var students = [StudentLocation]()
        
        for result in results {
            students.append(StudentLocation(parse: result))
        }
        
        return students
    }

}
