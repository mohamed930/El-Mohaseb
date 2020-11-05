//
//  LoginViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 11/3/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import ProgressHUD

class LoginViewController: UIViewController {
    
    var loginview: LoginView! {
        guard isViewLoaded else { return nil }
        return (view as! LoginView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func BTNLogin (_ sender:Any) {
        MakeLogin()
    }
    
    @IBAction func BTNSignup (_ sender:Any) {
        Tools.openForm(MainViewName: "Main", FormID: "SignupView", ob: self)
    }
    
    func MakeLogin () {
        
        if loginview.UserNameTextField.text == "" || loginview.PasswordTextField.text == "" {
            Tools.createAlert(Title: "Error", Mess: "Please fill All Fields", ob: self)
        }
        else {
            
            Firebase.MakeLogin(Email: loginview.UserNameTextField.text! , Password: loginview.PasswordTextField.text!) { (response) in
                if response == "Success" {
                    Tools.openForm(MainViewName: "Main", FormID: "HomeView", ob: self)
                }
                else {
                    self.loginview.PasswordTextField.text = ""
                }
            }
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == loginview.UserNameTextField {
            loginview.UserNameTextField.becomeFirstResponder()
        }
        else if textField == loginview.PasswordTextField {
            self.view.endEditing(true)
            // MakeLogin Operation.
            MakeLogin()
        }
        return true
    }
}
