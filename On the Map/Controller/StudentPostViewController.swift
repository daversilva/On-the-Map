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
    @IBOutlet weak var findLocationButton: BorderedButton!
    
    override var activityIndicatorTag: Int { get { return ViewTag.studentPost.rawValue } }
    
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
            showAlert(self, StudentClient.Messages.CompleteFields)
            return
        }
        
        setUIEnabled(false)
        startActivityIndicator()
        
        getLocation { (sucess, error) in
            if sucess {
                self.setUIEnabled(true)
                self.stopActivityIndicator()
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "segueAddLocation", sender: nil)
                }
            } else {
                print(error!)
                self.setUIEnabled(true)
                self.stopActivityIndicator()
                self.showAlert(self, StudentClient.Messages.NotPossibleDisplayLocation)
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
                completionHandlerForLocation(false, StudentClient.Messages.LocationNotFound)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                completionHandlerForLocation(false, StudentClient.Messages.LocationNotFound)
                return
            }
            
            if let coordinate = placemark.location?.coordinate {
                self.latitude = coordinate.latitude
                self.longitude = coordinate.longitude
                completionHandlerForLocation(true, nil)
            } else {
                completionHandlerForLocation(false, StudentClient.Messages.LocationNotFound)
            }
        }
    }
    
}

extension StudentPostViewController {
    func setUIEnabled(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.location.isEnabled = enabled
            self.location.isEnabled = enabled
            self.findLocationButton.isEnabled = enabled
            self.findLocationButton.alpha = enabled ? 1.0 : 0.5
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
