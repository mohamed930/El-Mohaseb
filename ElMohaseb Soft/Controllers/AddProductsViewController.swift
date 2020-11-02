//
//  AddProductsViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 11/1/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import DropDown

class AddProductsViewController: UIViewController {
    
    static var ProductcName: String?
    static var Flag: String?
    var menu:DropDown!
    
    var addproductsview: AddProductsView! {
        guard isViewLoaded else { return nil }
        return (view as! AddProductsView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Tools.SetBorder(textfield: addproductsview.ProductNameTextField , paddingValue: 20, PlaceHolder: "إسم الصنف", Color: UIColor().hexStringToUIColor(hex: "#585858"))
        Tools.SetBorderWithoutPadding(textfield: addproductsview.DetailsTextField, PlaceHolder: "تفاصيل آحرى", Color: UIColor().hexStringToUIColor(hex: "#585858"))
        
        if (AddProductsViewController.Flag == "1") {
            addproductsview.ProductNameTextField.text = AddProductsViewController.ProductcName!
        }
        
    }
    
    // MARK:- TODO:- This Action Method For Add Button.
    @IBAction func BTNAdd (_ sender:Any) {
        Tools.openForm(MainViewName: "Main", FormID: "AddSalesView", ob: self)
    }
    
    // MARK:- TODO:- This Action Method For Back Button.
    @IBAction func BTNBack (_ sender:Any) {
        self.dismiss(animated: true , completion: nil)
    }
    
    // MARK:- TODO:- This Action Method For Cancel Button.
    @IBAction func BTNCancel (_ sender:Any) {
        self.dismiss(animated: true , completion: nil)
    }
    
    // MARK:- TODO:- DropDown Menu Action.
    func MakeDropDown() {
        menu = {
            let menu = DropDown()
            menu.dataSource = ["Water","Pears","Sos"]
            return menu
        }()
        menu.anchorView   = addproductsview.ProductNameTextField
        menu.bottomOffset = CGPoint(x: 0, y:(menu.anchorView?.plainView.bounds.height)!)
        
        menu.selectionAction = {
                   index , title in
            self.addproductsview.ProductNameTextField.text = title
            
            // Make Place Holder From Database and request foucus on ammount.
            self.addproductsview.AmountTextField.becomeFirstResponder()
            
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension AddProductsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            MakeDropDown()
            menu.show()
        }
        else if textField.tag == 2 {
            addproductsview.Line1.backgroundColor = UIColor.systemPink
            addproductsview.Line2.backgroundColor = UIColor.lightGray
            addproductsview.Line3.backgroundColor = UIColor.lightGray
        }
        else if textField.tag == 3 {
            addproductsview.Line1.backgroundColor = UIColor.lightGray
            addproductsview.Line2.backgroundColor = UIColor.systemPink
            addproductsview.Line3.backgroundColor = UIColor.lightGray
        }
        else if textField.tag == 4 {
            addproductsview.Line1.backgroundColor = UIColor.lightGray
            addproductsview.Line2.backgroundColor = UIColor.lightGray
            addproductsview.Line3.backgroundColor = UIColor.systemPink
        }
        else {
            addproductsview.Line1.backgroundColor = UIColor.lightGray
            addproductsview.Line2.backgroundColor = UIColor.lightGray
            addproductsview.Line3.backgroundColor = UIColor.lightGray
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == addproductsview.ProductNameTextField {
            addproductsview.AmountTextField.becomeFirstResponder()
            menu.hide()
        }
        else if textField == addproductsview.AmountTextField {
            addproductsview.PriceTextField.becomeFirstResponder()
        }
        else if textField == addproductsview.PriceTextField{
            addproductsview.TotalPriceTextField.becomeFirstResponder()
        }
        else if textField == addproductsview.TotalPriceTextField {
            addproductsview.DetailsTextField.becomeFirstResponder()
        }
        else {
            // Add Product
            if (AddProductsViewController.Flag == "1") {
                // Add Product into Table.
                
            }
            else {
                // Add Product into Database.
                
            }
        }
        return true
    }
}
