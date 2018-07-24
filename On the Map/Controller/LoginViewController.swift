//
//  LoginViewController.swift
//  On the Map
//
//  Created by David Rodrigues on 19/07/2018.
//  Copyright © 2018 David Rodrigues. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: Actions
    
    @IBAction func loginPressed(_ sender: BorderedButton) {
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            displayError(UdacityClient.Messages.EmailOrPasswordEmpty)
        } else {
            setUIEnabled(false)
            
            let credentials = StudentCredential(username: emailTextField.text!, password: passwordTextField.text!)
            
            UdacityClient.sharedInstance().loginWithCredentials(credentials) { (success, sessionId, error) in
                if success {
                    print(sessionId!)
                } else {
                    print(error!)
                    self.displayError(UdacityClient.Messages.EmailOrPasswordWrong)
                }
                
                self.setUIEnabled(true)
            }
        }
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        UIApplication.shared.open(URL(string : UdacityClient.Constants.AccountSignUpURL)!, options: [:], completionHandler: nil)
    }
 
}

// MARK: LoginViewController - (Configure UI)

private extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.emailTextField.isEnabled = enabled
            self.passwordTextField.isEnabled = enabled
            self.loginButton.isEnabled = enabled
            self.loginButton.alpha = enabled ? 1.0 : 0.5
        }
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
