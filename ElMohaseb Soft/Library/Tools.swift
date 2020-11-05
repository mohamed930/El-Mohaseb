//
//  Tools.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 11/1/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit

class Tools {
    public static func openForm (MainViewName:String,FormID:String,ob:UIViewController) {
        let storyBoard = UIStoryboard(name: MainViewName, bundle: nil)
        let next = storyBoard.instantiateViewController(withIdentifier: FormID)
        next.modalPresentationStyle = .fullScreen
        ob.present(next, animated: true, completion: nil)
    }
    
    public static func MakeViewLine (view:UIView) {
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor().hexStringToUIColor(hex: "#0A6EA9").cgColor
        view.layer.cornerRadius = 11
        view.layer.masksToBounds = true
    }
    
    public static func SetBorder(textfield: UITextField,paddingValue:Int,PlaceHolder:String , Color:UIColor) {
        textfield.layer.borderWidth = 0.8
        textfield.layer.borderColor = UIColor().hexStringToUIColor(hex: "#606060").cgColor
        textfield.layer.cornerRadius = 7.0
        textfield.layer.masksToBounds = true
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: paddingValue, height: 20))
        textfield.rightView = paddingView
        textfield.rightViewMode = .always
        
        textfield.attributedPlaceholder = NSAttributedString(string: PlaceHolder,
        attributes: [NSAttributedString.Key.foregroundColor: Color])
    }
    
    public static func SetBorderWithoutPadding (textfield: UITextField,PlaceHolder:String , Color:UIColor) {
        textfield.layer.borderWidth = 0.8
        textfield.layer.borderColor = UIColor().hexStringToUIColor(hex: "#606060").cgColor
        textfield.layer.cornerRadius = 7.0
        textfield.layer.masksToBounds = true
        
        textfield.attributedPlaceholder = NSAttributedString(string: PlaceHolder,
        attributes: [NSAttributedString.Key.foregroundColor: Color])
    }
    
    public static func createAlert (Title:String , Mess:String , ob:UIViewController)
    {
        let alert = UIAlertController(title: Title , message:Mess
            , preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"OK",style:UIAlertAction.Style.default,handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        ob.present(alert,animated:true,completion: nil)
    }
}
