//
//  StudentTabBarController.swift
//  On the Map
//
//  Created by David Rodrigues on 02/08/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit

class StudentTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    @IBOutlet weak var logout: UIBarButtonItem!
    @IBOutlet weak var refresh: UIBarButtonItem!
    @IBOutlet weak var addStudent: UIBarButtonItem!
    
    var students = StudentArray.sharedInstance().studentLocations
    
    override var activityIndicatorTag: Int { get { return ViewTag.studentTabBar.rawValue } }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        logoutUdacity()
        logoutFacebook()
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        startActivityIndicator()
        setUIEnable(false)
        
        StudentClient.sharedInstance().loadStudents() { (results, success, error) in
            if success {
                DispatchQueue.main.async {
                    self.students.append(contentsOf: results)
                }
            } else {
                print(error!)
                self.showAlert(self, StudentClient.Messages.NotPossibleDisplayStudents)
            }
        }
        
        setUIEnable(true)
        stopActivityIndicator()
    }
    
    // MARK: Methods
    
    func logoutUdacity() {
        UdacityClient.sharedInstance().logoutSessionUdacity { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print(error!)
            }
        }
    }
    
    func logoutFacebook() {
        UdacityClient.sharedInstance().logoutSessionFacebook { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print(error!)
            }
        }
    }
}

extension StudentTabBarController {
    func setUIEnable(_ enable: Bool) {
        logout.isEnabled = enable
        refresh.isEnabled = enable
        addStudent.isEnabled = enable
    }
}
