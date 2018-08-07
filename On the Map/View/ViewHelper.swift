//
//  CommomActivity.swift
//  On the Map
//
//  Created by David Rodrigues on 04/08/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit

class ViewHelper {
    
    open func displayError(_ view: UIViewController, _ errorString: String?) {
        if let errorString = errorString {
            let alert = UIAlertController(title: UdacityClient.Messages.OnTheMap, message: errorString, preferredStyle: .alert)
            let action = UIAlertAction(title: UdacityClient.Messages.Dismiss, style: .default, handler: nil)
            
            alert.addAction(action)
            
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ViewHelper {
        struct Singleton {
            static var sharedInstance = ViewHelper()
        }
        return Singleton.sharedInstance
    }
}

enum ViewTag: Int {
    case login = 1, studentTable, studentMapKit, studentTabBar, studentPost, studentPostMapKit
}

extension UIViewController {
    
    @objc dynamic var activityIndicatorTag: Int { return 999999 }
    
    func startActivityIndicator(style: UIActivityIndicatorViewStyle = .white, location: CGPoint? = nil) {
        
        let loc = location ?? self.view.center
        
        DispatchQueue.main.async {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: style)
            
            activityIndicator.tag = self.activityIndicatorTag
            activityIndicator.center = loc
            activityIndicator.color = UIColor(red: 0.0, green: 162.0/255.0, blue: 218.0/255, alpha: 1.0)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            
            self.view.addSubview(activityIndicator)
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            if let activityIndicator = self.view.subviews.filter({ $0.tag == self.activityIndicatorTag }).first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
    
}
