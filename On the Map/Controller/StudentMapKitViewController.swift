//
//  StudentMapKitViewController.swift
//  On the Map
//
//  Created by David Rodrigues on 31/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit
import MapKit

class StudentMapKitViewController: UIViewController {
    
    @IBOutlet weak var studentMap: MKMapView!
    
    var annotations = [MKPointAnnotation]()
    
    var students: [StudentLocation]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.studentLocations
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentMap.delegate = self
        
        loadStudent()
        // Do any additional setup after loading the view.
    }

    private func loadStudent() {
        StudentClient.sharedInstance().loadStudents() { (results, success, error) in
            if success {
                print("passed here")
                DispatchQueue.main.async {
                    let object = UIApplication.shared.delegate
                    let appDelegate = object as! AppDelegate
                    appDelegate.studentLocations.append(contentsOf: results)
                    self.loadStudentsInMapView()
                    self.studentMap.reloadInputViews()
                    
                }
            }
        }
    }
    
    func loadStudentsInMapView() {
        
        for student in students {
            
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL
            
            annotations.append(annotation)
        }
        
        self.studentMap.addAnnotations(annotations)
    }
    
}

extension StudentMapKitViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "locationPin"
        
        var studentView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if studentView == nil {
            studentView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            studentView!.canShowCallout = true
            studentView?.pinTintColor = .red
            studentView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            studentView!.annotation = annotation
        }
        
        return studentView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            guard let subtitle = view.annotation?.subtitle!, let url = URL(string: subtitle) else {
                print("Invalid input URL")
                return
            }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Doesn't possible open URL")
            }

        }
    }
}
