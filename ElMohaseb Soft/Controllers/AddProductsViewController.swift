//
//  AddProductsViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 11/1/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit

class AddProductsViewController: UIViewController {
    
    static var ProductcName: String?
    static var Flag: String?
    
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
    
    // MARK:- TODO:- This Action Method For Back Button.
    @IBAction func BTNBack (_ sender:Any) {
        self.dismiss(animated: true , completion: nil)
    }
    
    // MARK:- TODO:- This Action Method For Cancel Button.
    @IBAction func BTNCancel (_ sender:Any) {
        self.dismiss(animated: true , completion: nil)
    }
}
