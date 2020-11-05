//
//  AddProductsViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 11/1/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import DropDown
import FirebaseAuth
import RappleProgressHUD

protocol AddedProdcuts {
    func NewProduct (Name:String,Ammount:String,Price:String)
}

class AddProductsViewController: UIViewController {
    
    var ProductcName: String?
    var Flag: String?
    var menu:DropDown!
    var delegate: AddedProdcuts!
    var arr = Array<Products>()
    var Names = [""]
    var Choice = false
    
    var addproductsview: AddProductsView! {
        guard isViewLoaded else { return nil }
        return (view as! AddProductsView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Tools.SetBorder(textfield: addproductsview.ProductNameTextField , paddingValue: 20, PlaceHolder: "إسم الصنف", Color: UIColor().hexStringToUIColor(hex: "#585858"))
        Tools.SetBorderWithoutPadding(textfield: addproductsview.DetailsTextField, PlaceHolder: "تفاصيل آحرى", Color: UIColor().hexStringToUIColor(hex: "#585858"))
        AddNext(textField: addproductsview.AmountTextField)
        AddNext(textField: addproductsview.PriceTextField)
        AddNext(textField: addproductsview.TotalPriceTextField)
        
        if (Flag == "1") {
            addproductsview.ProductNameTextField.text = ProductcName!
        }
        
        FillData()
        
    }
    
    // MARK:- TODO:- This Action Method For Add Button.
    @IBAction func BTNAdd (_ sender:Any) {
        
        if addproductsview.ProductNameTextField.text == "" || addproductsview.PriceTextField.text == "" || addproductsview.AmountTextField.text == "" || addproductsview.TotalPriceTextField.text == "" {
            Tools.createAlert(Title: "خطا", Mess: "ارجوك املى جميع الخانات", ob: self)
        }
        else {
            
            if Flag == "1" || Choice == true {
                self.delegate.NewProduct(Name: addproductsview.ProductNameTextField.text! , Ammount: addproductsview.AmountTextField.text!, Price: addproductsview.PriceTextField.text!)
                self.dismiss(animated: true, completion: nil)
            }
            else {
                // Send To DataBase First and put it in resete.
                AddNewProduct()
            }
        }
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
            menu.dataSource = Names
            return menu
        }()
        menu.anchorView   = addproductsview.ProductNameTextField
        menu.bottomOffset = CGPoint(x: 0, y:(menu.anchorView?.plainView.bounds.height)!)
        
        menu.selectionAction = {
                   index , title in
            self.addproductsview.ProductNameTextField.text = title
            
            // Make Place Holder From Database and request foucus on ammount.
            self.addproductsview.AmountTextField.becomeFirstResponder()
            self.Choice = true
            for i in self.arr {
                if i.Name == title {
                    self.addproductsview.AmountTextField.placeholder = String(i.Ammount!)
                    self.addproductsview.PriceTextField.placeholder = String(i.Price!)
                    self.addproductsview.TotalPriceTextField.placeholder = String(i.FinalPrice!)
                    self.addproductsview.DetailsTextField.placeholder = String(i.Notes!)
                }
            }
            
        }
    }
    
    // MARK:- TODO:- This Function For SendNew Prduct to DataBase.
    func AddNewProduct () {
        
        let data = ["ProductName":addproductsview.ProductNameTextField.text! as Any,
                    "Ammount": addproductsview.AmountTextField.text! as Any,
                    "Price": addproductsview.PriceTextField.text! as Any,
                    "TotalPrice": addproductsview.TotalPriceTextField.text! as Any,
                    "Notes": addproductsview.DetailsTextField.text! ,
                    "EmailID": Auth.auth().currentUser?.email! as Any
                   ] 
        
        Firebase.addData(collectionName: "Products", data: data, SuccessMessage: "Added Sucess")
        
        self.delegate.NewProduct(Name: addproductsview.ProductNameTextField.text! , Ammount: addproductsview.AmountTextField.text!, Price: addproductsview.PriceTextField.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK:- TODO- Fucntion Fill ProductsName.
    func FillData () {
        
        Names.removeAll()
        
        Firebase.publicreadWithWhereCondtion(collectionName: "Products", key: "EmailID", value: (Auth.auth().currentUser?.email!)!) { (query) in
            
            RappleActivityIndicatorView.stopAnimation()
            
             for q in query.documents {
                let ob = Products()
                ob.Name = (q.get("ProductName") as! String)
                ob.Ammount = Int ((q.get("Ammount") as! String))
                ob.Price = Int ((q.get("Price") as! String))
                ob.FinalPrice = Int ((q.get("TotalPrice") as! String))
                ob.Notes = (q.get("Notes") as! String)
                self.arr.append(ob)
                self.Names.append(q.get("ProductName") as! String)
            }
            
        }
    }
    
    func AddNext (textField: UITextField) {
        let numberToolbar: UIToolbar = UIToolbar()
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.plain, target: self, action: #selector(Next))
        ]

        numberToolbar.sizeToFit()

        textField.inputAccessoryView = numberToolbar
    }
    
    @objc func Next () {
        if (addproductsview.AmountTextField.resignFirstResponder()) {
            addproductsview.PriceTextField.becomeFirstResponder()
        }
        else if (addproductsview.PriceTextField.resignFirstResponder()) {
            addproductsview.TotalPriceTextField.placeholder = String( Int(addproductsview.PriceTextField.text!)! * Int(addproductsview.AmountTextField.text!)!)
            addproductsview.TotalPriceTextField.becomeFirstResponder()
        }
        else {
            addproductsview.DetailsTextField.becomeFirstResponder()
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
            if (Flag == "1") {
                // Add Product into Table.
                
            }
            else {
                // Add Product into Database.
                
            }
        }
        return true
    }
}
