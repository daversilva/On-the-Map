//
//  StudentTableViewController.swift
//  On the Map
//
//  Created by David Rodrigues on 27/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {
    
    var students: [StudentLocation]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.studentLocations
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadStudent()
    }
    
    private func loadStudent() {
        StudentClient.sharedInstance().loadStudents() { (results, success, error) in
            if success {
                print(results)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

}
