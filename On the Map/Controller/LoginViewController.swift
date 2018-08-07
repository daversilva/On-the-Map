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
    @IBOutlet weak var loginFacebookButton: LoginFacebookButton!
    
    override var activityIndicatorTag: Int { get { return ViewTag.login.rawValue } }
    
    // MARK: Reachability
    let reachability = Reachability()!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    // MARK: Actions
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if reachability.connection == .none {
            showAlert(self, UdacityClient.Messages.NoConnection)
            return
        }

        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            showAlert(self, UdacityClient.Messages.EmailOrPasswordEmpty)
            return
        }

        setUIEnabled(false)
        startActivityIndicator()

        let credentials = UdacityCredential(username: emailTextField.text!, password: passwordTextField.text!)

        UdacityClient.sharedInstance().loginWithCredentials(credentials) { (success, error) in

            if success {
                self.loginSuccess()
                self.setUIEnabled(true)
                self.stopActivityIndicator()
            } else {
                print(error!)
                self.showAlert(self, UdacityClient.Messages.EmailOrPasswordWrong)
                self.setUIEnabled(true)
                self.stopActivityIndicator()
            }
        }
    }
    
    @IBAction func loginWithFacebookPressed(_ sender: LoginFacebookButton) {
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.loginBehavior = FBSDKLoginBehavior.web
        
        loginManager.logIn(withPublishPermissions: [], from: self) { (result, error) in
            
            guard (error == nil) else {
                self.showAlert(self, UdacityClient.Messages.LoginError)
                return
            }
            
            guard let _ = result?.token, let accessToken = FBSDKAccessToken.current().tokenString else {
                self.showAlert(self,UdacityClient.Messages.TokenError)
                return
            }
            
            self.setUIEnabled(false)
            self.startActivityIndicator()
            
            UdacityClient.sharedInstance().loginWithFacebook(accessToken) { (success, error) in
                
                if success {
                    self.loginSuccess()
                    self.setUIEnabled(true)
                    self.stopActivityIndicator()
                } else {
                    print(error!)
                    self.showAlert(self, UdacityClient.Messages.FacebookError)
                    self.setUIEnabled(true)
                    self.stopActivityIndicator()
                }
            }
        }
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        UIApplication.shared.open(URL(string : UdacityClient.Constants.AccountSignUpURL)!, options: [:], completionHandler: nil)
    }

}

// MARK: LoginViewController - (Configure UI)

private extension LoginViewController {
    
    // MARK: Helpers
    
    func setUIEnabled(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.emailTextField.isEnabled = enabled
            self.passwordTextField.isEnabled = enabled
            self.loginButton.isEnabled = enabled
            self.loginButton.alpha = enabled ? 1.0 : 0.5
            self.loginFacebookButton.isEnabled = enabled
            self.loginFacebookButton.alpha = enabled ? 1.0 : 0.5
        }
    }
    
    func loginSuccess() {
        performSegue(withIdentifier: "segueLogin", sender: nil)
    }
}

// MARK: LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
