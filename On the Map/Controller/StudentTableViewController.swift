//
//  StudentTableViewController.swift
//  On the Map
//
//  Created by David Rodrigues on 27/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {
    
    var students = StudentArray.sharedInstance().studentLocations
    
    override var activityIndicatorTag: Int { get { return ViewTag.studentTable.rawValue } }

    override func viewDidLoad() {
        super.viewDidLoad()

        startActivityIndicator()
        loadStudent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func loadStudent() {
        StudentClient.sharedInstance().loadStudents() { (results, success, error) in
            if success {
                DispatchQueue.main.async {
                    self.students.append(contentsOf: results)
                    self.tableView.reloadData()
                }
            } else {
                print(error!)
                DispatchQueue.main.async {
                    ViewHelper.sharedInstance().displayError(self, StudentClient.Messages.NotPossibleDownloadStudents)
                }
            }
        }
    }
}
    // MARK: - Table view data source

extension StudentTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath) as! StudentTableViewCell
        let student = students[(indexPath as NSIndexPath).row]
        
        cell.firstLastName.text = "\(student.firstName) \(student.lastName)"
        cell.mediaUrl.text = student.mediaURL
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! StudentTableViewCell
        
        guard let url = URL(string: (cell.mediaUrl?.text)!) else {
            print("Invalid input URL!")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Doesn't possible open URL")
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell: StudentTableViewCell = cell as! StudentTableViewCell
        
        if let text = cell.firstLastName.text, !text.isEmpty {
            stopActivityIndicator()
        }
    }
    
}
