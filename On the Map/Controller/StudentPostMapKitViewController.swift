//
//  StudentPostMapKitViewController.swift
//  On the Map
//
//  Created by David Rodrigues on 03/08/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit
import MapKit

class StudentPostMapKitViewController: UIViewController {

    @IBOutlet weak var studentMapView: MKMapView!
    
    override var activityIndicatorTag: Int { get { return ViewTag.studentPostMapKit.rawValue } }
    
    let Helper = ViewHelper.sharedInstance()
    
    var mapString = ""
    var website = ""
    var latitude = 0.0
    var longitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentMapView.delegate = self
        loadStudentLocationInMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startActivityIndicator()
    }
    
    @IBAction func postNewLocation(_ sender: UIButton) {
        
        let location = Location(mapString: mapString, mediaURL: website, latitude: latitude, longitude: longitude)
        startActivityIndicator()
        
        StudentClient.sharedInstance().postStudent(location: location) { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.Helper.displayError(self, StudentClient.Messages.UnablePostLocation)
                    self.stopActivityIndicator()
                }
            }
        }
    }
    
    func loadStudentLocationInMapView() {
        
        let lat = CLLocationDegrees(latitude)
        let long = CLLocationDegrees(longitude)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(2.5/180.0), longitudeDelta: CLLocationDegrees(2.5/180.0))
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(UdacityClient.sharedInstance().firstName ?? "First-Name") \(UdacityClient.sharedInstance().lastName ?? "Last-Name")"
        
        studentMapView.addAnnotation(annotation)
        studentMapView.setRegion(region, animated: true)
    }
    
}

extension StudentPostMapKitViewController: MKMapViewDelegate {
    
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
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        stopActivityIndicator()
    }
}
