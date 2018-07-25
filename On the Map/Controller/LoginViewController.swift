//
//  LoginViewController.swift
//  On the Map
//
//  Created by David Rodrigues on 19/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var loginWithFacebookButton: LoginFacebookButton!
    
    let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
    
    // MARK: Reachability
    let reachability = Reachability()!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureActivityIndicator()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    // MARK: Actions
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if reachability.connection == .none {
            displayError(UdacityClient.Messages.NoConnection)
            return
        }
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            displayError(UdacityClient.Messages.EmailOrPasswordEmpty)
            return
        }
        
        setUIEnabled(false)
        self.activityIndicator.startAnimating()

        let credentials = StudentCredential(username: emailTextField.text!, password: passwordTextField.text!)
        
        UdacityClient.sharedInstance().loginWithCredentials(credentials) { (success, error) in
            
            if success {
                print(UdacityClient.sharedInstance().sessionID!)
            } else {
                print(error!)
                self.displayError(UdacityClient.Messages.EmailOrPasswordWrong)
            }
            
            DispatchQueue.main.async {
                self.setUIEnabled(true)
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func loginWithFacebookPressed(_ sender: LoginFacebookButton) {
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.loginBehavior = FBSDKLoginBehavior.web
        
        loginManager.logIn(withPublishPermissions: [], from: self) { (result, error) in
            
            guard (error == nil) else {
                self.displayError(UdacityClient.Messages.LoginError)
                return
            }
            
            guard let _ = result?.token, let accessToken = FBSDKAccessToken.current().tokenString else {
                self.displayError(UdacityClient.Messages.TokenError)
                return
            }
            
            self.setUIEnabled(false)
            self.activityIndicator.startAnimating()
            
            UdacityClient.sharedInstance().loginWithFacebook(accessToken) { (success, error) in
                
                if success {
                    print(UdacityClient.sharedInstance().sessionID!)
                } else {
                    print(error!)
                    self.displayError(UdacityClient.Messages.FacebookError)
                }
                
                DispatchQueue.main.async {
                    self.setUIEnabled(true)
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.activityIndicator.stopAnimating()
                }
            }
            
        }
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        UIApplication.shared.open(URL(string : UdacityClient.Constants.AccountSignUpURL)!, options: [:], completionHandler: nil)
    }
 
    private func configureActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.color = UIColor(red: 0.0, green: 162.0/255.0, blue: 218.0/255, alpha: 1.0)
        view.addSubview(activityIndicator)
    }
}

// MARK: LoginViewController - (Configure UI)

private extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        loginButton.alpha = enabled ? 1.0 : 0.5
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            let alert = UIAlertController(title: UdacityClient.Messages.OnTheMap, message: errorString, preferredStyle: .alert)
            let action = UIAlertAction(title: UdacityClient.Messages.Dismiss, style: .default, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
