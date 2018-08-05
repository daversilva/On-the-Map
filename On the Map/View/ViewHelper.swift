//
//  CommomActivity.swift
//  On the Map
//
//  Created by David Rodrigues on 04/08/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit

class ViewHelper {
    
    let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .white)

    open func configureActivityIndicator(_ view: UIView) {
        activityIndicator.center = view.center
        activityIndicator.color = UIColor(red: 0.0, green: 162.0/255.0, blue: 218.0/255, alpha: 1.0)
        view.addSubview(activityIndicator)
    }
    
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
