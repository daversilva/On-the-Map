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
    
    func postStudent(location: Location, completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let jsonBody = "{\"\(StudentClient.JSONBody.UniqueKey)\": \"\(UdacityClient.sharedInstance().userID!)\", \"\(StudentClient.JSONBody.FirstName)\": \"\(UdacityClient.sharedInstance().firstName!)\", \"\(StudentClient.JSONBody.LastName)\": \"\(UdacityClient.sharedInstance().lastName!)\",\"\(StudentClient.JSONBody.MapString)\": \"\(location.mapString)\", \"\(StudentClient.JSONBody.MediaUrl)\": \"\(location.mediaURL)\",\"\(StudentClient.JSONBody.Latitude)\": \(location.latitude), \"\(StudentClient.JSONBody.Longitude)\": \(location.longitude)}"
        
        let _ = taskForPostMethod(jsonBody: jsonBody) { (success, error) in
            if success {
                completionHandler(true, nil)
            } else {
                completionHandler(false, error!)
            }
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
