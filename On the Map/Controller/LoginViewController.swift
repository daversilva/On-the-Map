//
//  LoginViewController.swift
//  On the Map
//
//  Created by David Rodrigues on 19/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginPressed(_ sender: BorderedButton) {
    }
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        UIApplication.shared.open(URL(string : UdacityClient.Constants.AccountSignUpURL)!, options: [:], completionHandler: nil )
    }
    
}
