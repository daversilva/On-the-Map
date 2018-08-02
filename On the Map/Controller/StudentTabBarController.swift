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


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func addStudentButton(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
    }
    
}
