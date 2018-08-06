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

    override func viewDidLoad() {
        super.viewDidLoad()

        ViewHelper.sharedInstance().configureActivityIndicator(view)
    }

    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        logoutUdacity()
        logoutFacebook()
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        ViewHelper.sharedInstance().activityIndicator.startAnimating()
        setUIEnable(false)
        
        StudentClient.sharedInstance().loadStudents() { (results, success, error) in
            if success {
                DispatchQueue.main.async {
                    self.students.append(contentsOf: results)
                }
            } else {
                print(error!)
                DispatchQueue.main.async {
                    ViewHelper.sharedInstance().displayError(self, StudentClient.Messages.NotPossibleDisplayStudents)
                }
            }
        }
        
        setUIEnable(true)
        ViewHelper.sharedInstance().activityIndicator.stopAnimating()
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
}

extension StudentTabBarController {
    func setUIEnable(_ enable: Bool) {
        logout.isEnabled = enable
        refresh.isEnabled = enable
        addStudent.isEnabled = enable
    }
}
