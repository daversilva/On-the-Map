//
//  StudentLocationPostViewController.swift
//  On the Map
//
//  Created by David Rodrigues on 02/08/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit
import MapKit

class StudentPostViewController: UIViewController {
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var mediaUrl: UITextField!
    
    var latitude = 0.0
    var longitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        location.delegate = self
        mediaUrl.delegate = self
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func findLocation(_ sender: UIButton) {

        if location.text!.isEmpty || mediaUrl.text!.isEmpty {
            ViewHelper.sharedInstance().displayError(self, "Complete all fields")
            return
        }
        
        getLocation { (sucess, error) in
            if sucess {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "segueAddLocation", sender: nil)
                }
            } else {
                print(error!)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueAddLocation" {
            let destination = segue.destination as! StudentPostMapKitViewController
            destination.mapString = self.location.text!
            destination.website = self.mediaUrl.text!
            destination.longitude = longitude
            destination.latitude = latitude
        }
    }
    
    func getLocation(completionHandlerForLocation: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        CLGeocoder().geocodeAddressString(location.text!) { (placemarks, error) in
            
            guard (error == nil) else {
                completionHandlerForLocation(false, "Location not find")
                return
            }
            
            guard let placemark = placemarks?[0] else {
                completionHandlerForLocation(false, "Location not find")
                return
            }
            
            if let coordinate = placemark.location?.coordinate {
                self.latitude = coordinate.latitude
                self.longitude = coordinate.longitude
                completionHandlerForLocation(true, nil)
            } else {
                completionHandlerForLocation(false, "Location not find")
            }
        }
    }
    
}

// MARK: StudentPostViewController: UITextFieldDelegate

extension StudentPostViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
