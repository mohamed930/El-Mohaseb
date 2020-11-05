//
//  SignupViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 11/3/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    var screenedge : UIScreenEdgePanGestureRecognizer!
    
    var signupview: SignupView! {
        guard isViewLoaded else { return nil }
        return (view as! SignupView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK:- TODO:- This Line for adding Geusters.
        screenedge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(Back(_:)))
        screenedge.edges = .left
        view.addGestureRecognizer(screenedge)
    }
    
    @IBAction func BTNSginup (_ sender:Any) {
        Signup()
    }
    
    // MARK:- TODO:- This is Method For Signup Operation.
    func Signup () {
        
        if signupview.UserNameTextField.text == "" || signupview.PasswordTextField.text == "" {
            Tools.createAlert(Title: "Error", Mess: "Please Fill All Fields", ob: self)
        }
        else {
            
            let emails = ["Email": signupview.UserNameTextField.text!]
            
            Firebase.createAccount(Email: signupview.UserNameTextField.text!, Password: signupview.PasswordTextField.text! , collectionName: "Users", data: emails, SuccessMessage: "Account is created Successfully!")
        }
    }
    
    // MARK:- TODO:- This Method For Add GuesterAction
    @objc func Back (_ sender:UIScreenEdgePanGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == signupview.UserNameTextField {
            signupview.PasswordTextField.becomeFirstResponder()
        }
        else {
            // Make Login Operation
            self.view.endEditing(true)
            Signup()
        }
        
        return true
    }
}
