//
//  Firebase.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 11/4/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import RappleProgressHUD
import ProgressHUD

class Firebase {
    // MARK:- TODO:- This Method For Signup completly to Firebase.
    public static func createAccount(Email:String,Password:String,collectionName:String,data:[String:String],SuccessMessage:String) {
        
        Auth.auth().createUser(withEmail: Email, password: Password) { (auth, error) in
            if error != nil {
                RappleActivityIndicatorView.stopAnimation()
                ProgressHUD.showError("Your Data not created Successed!")
            }
            else {
                self.addData(collectionName: collectionName, data: data,SuccessMessage: SuccessMessage)
            }
        }
    }
    
    // MARK:- TODO:- This Method For Adding Data to Firebase.
    public static func addData (collectionName:String,data:[String:Any],SuccessMessage:String) {
        
        RappleActivityIndicatorView.startAnimatingWithLabel("loading", attributes: RappleModernAttributes)
        Firestore.firestore().collection(collectionName).document().setData(data){
            error in
            if error != nil {
                RappleActivityIndicatorView.stopAnimation()
                ProgressHUD.showError(SuccessMessage)
            }
            else {
                RappleActivityIndicatorView.stopAnimation()
                ProgressHUD.showSuccess("Your Data created Successed!")
            }
        }
    }
    
    // MARK:- TODO:- This Method For Make a login opertation.
    public static func MakeLogin (Email:String,Password:String,completion: @escaping (String) -> ())  {
        
        RappleActivityIndicatorView.startAnimatingWithLabel("loading", attributes: RappleModernAttributes)
        
        Auth.auth().signIn(withEmail: Email, password: Password) { (auth, error) in
            if error != nil {
                RappleActivityIndicatorView.stopAnimation()
                ProgressHUD.showError("Your \(error!.localizedDescription)")
                completion("Failed")
            }
            else {
                RappleActivityIndicatorView.stopAnimation()
                completion("Success")
            }
        }
        
    }
    
    // MARK:- TODO:- This Method for Read Data from Firebase with condtion in public.
    public static func publicreadWithWhereCondtion (collectionName:String , key:String , value:String , complention: @escaping (QuerySnapshot) -> ()) {
        
        RappleActivityIndicatorView.startAnimatingWithLabel("loading", attributes: RappleModernAttributes)
        Firestore.firestore().collection(collectionName).whereField(key, isEqualTo: value).getDocuments { (quary, error) in
            if error != nil {
                RappleActivityIndicatorView.stopAnimation()
                ProgressHUD.showError("We Can't Find Your Data!")
            }
            else {
                complention(quary!)
            }
        }
    }
}