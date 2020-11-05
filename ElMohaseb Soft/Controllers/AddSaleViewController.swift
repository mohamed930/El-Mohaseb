//
//  AddSaleViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 11/1/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import YCActionSheetDatePicker
import DropDown

class AddSaleViewController: UIViewController {
    
    var screenedge : UIScreenEdgePanGestureRecognizer!
    var menu:DropDown!
    var ProductsArr = Array<Products>()
    var F = 0
    
    var addsalesview: AddSaleView! {
        guard isViewLoaded else { return nil }
        return (view as! AddSaleView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Tools.MakeViewLine(view: addsalesview.View1)
        Tools.MakeViewLine(view: addsalesview.View2)
        
        addsalesview.tableView.register(UINib(nibName: "ProductsCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        // MARK:- TODO:- This Line for adding Geusters.
        screenedge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(Back(_:)))
        screenedge.edges = .left
        view.addGestureRecognizer(screenedge)
    }
    
    // MARK:- TODO:- Button BackAction.
    @IBAction func BTNBack (_ sender:Any) {
        ActionBack(x: 1)
    }
    
    // MARK:- TODO:- Function Save.
    @IBAction func BTNSave (_ sender: Any) {
        SaveFullTableData(x: 0)
    }
    
    // MARK:- TODO:- Fucntion Show Date To Pickit.
    @IBAction func BTNShowData (_ sender:Any) {
        present(createActionSheetDatePicker(), animated: true, completion: nil)
    }
    
    // MARK:- TODO:- Function Add Products.
    @IBAction func BTNAddProducts (_ sender:Any) {
        F = 1
        self.performSegue(withIdentifier: "AddProduct", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddProduct" {
            if let vc = segue.destination as? AddProductsViewController {
                if F == 1 {
                    vc.Flag = "0"
                    vc.delegate = self
                }
                else if F == 2 {
                    vc.Flag = "1"
                    vc.ProductcName = self.addsalesview.ProductNameTextField.text!
                    vc.delegate = self
                }
            }
        }
    }
    
    private func createActionSheetDatePicker() -> YCActionSheetDatePickerVC {
        let vc = YCActionSheetDatePickerVC()
        vc.datePickerView.datePicker.datePickerMode = UIDatePicker.Mode.date
        vc.delegate = self
        return vc
    }
    
    // MARK:- TODO:- DropDown Menu Action.
    func MakeDropDown(x:Int) {
        
        switch(x) {
        case 1:
            SetMenuIntialize(ArrayData: ["Mohamed","Zyad","Ali"], PrintedTextField: addsalesview.CustomerNameTextField)
            break
        case 2:
            menu = {
                let menu = DropDown()
                menu.dataSource = ["Water","Pears","Sos"]
                return menu
            }()
            menu.anchorView   = addsalesview.ProductNameTextField
            menu.bottomOffset = CGPoint(x: 0, y:(menu.anchorView?.plainView.bounds.height)!)
            
            menu.selectionAction = {
                       index , title in
                self.addsalesview.ProductNameTextField.text = title
                
                // Open Products View.
                self.F = 2
                self.performSegue(withIdentifier: "AddProduct", sender: self)
            }
            break
        default:
            print("Else")
        }
        
        
    }
    
    // MARK:- TODO:- This For Intialize Menus
    func SetMenuIntialize (ArrayData:[String],PrintedTextField:UITextField) {
        menu = {
            let menu = DropDown()
            menu.dataSource = ArrayData
            return menu
        }()
        menu.anchorView   = PrintedTextField
        menu.bottomOffset = CGPoint(x: 0, y:(menu.anchorView?.plainView.bounds.height)!)
        
        menu.selectionAction = {
                   index , title in
            PrintedTextField.text = title
            
        }
    }

    // MARK:- TODO:- ActionBack function
    func ActionBack (x:Int) {
        let Alert = UIAlertController(title: "تاكيد", message: "هل تريد الحفظ؟", preferredStyle: .alert)
        
        Alert.addAction(UIAlertAction(title: "لا", style: .default, handler: {(alert) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        Alert.addAction(UIAlertAction(title: "نعم", style: .default, handler: { (alert) in
            
            print("Saved!")
            // MARK:- TODO:- Make Method Call SaveFullTableData To Save Data To Database.
            self.SaveFullTableData(x: x)
            
        }))
        
        self.present(Alert, animated: true, completion: nil)
    }
    
    // MARK:- TODO:- function SaveFullTableData.
    func SaveFullTableData(x:Int) {
        
        print("Saved")
        if (x == 1) {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    // MARK:- TODO:- This Method For Add GuesterAction
    @objc func Back (_ sender:UIScreenEdgePanGestureRecognizer) {
        ActionBack(x: 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension AddSaleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductsCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductsCell
        
        cell.ProductNameLabel.text = ProductsArr[indexPath.row].Name!
        cell.PriceLabel.text = String(ProductsArr[indexPath.row].Price!)
        cell.AmmountLabel.text = String(ProductsArr[indexPath.row].Ammount!)
        cell.FinalPrice.text = String(ProductsArr[indexPath.row].FinalPrice!)
        
        return cell
    }
}

extension AddSaleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 37.0
    }
}

extension AddSaleViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            addsalesview.Line1.backgroundColor = UIColor.systemPink
            addsalesview.Line2.backgroundColor = UIColor.lightGray
            addsalesview.Line3.backgroundColor = UIColor.lightGray
            addsalesview.Line4.backgroundColor = UIColor.lightGray
            MakeDropDown(x:1)
            menu.show()
        }
        else if textField.tag == 2 {
            addsalesview.Line1.backgroundColor = UIColor.lightGray
            addsalesview.Line2.backgroundColor = UIColor.systemPink
            addsalesview.Line3.backgroundColor = UIColor.lightGray
            addsalesview.Line4.backgroundColor = UIColor.lightGray
            menu.hide()
        }
        else if textField.tag == 3 {
            addsalesview.Line1.backgroundColor = UIColor.lightGray
            addsalesview.Line2.backgroundColor = UIColor.lightGray
            addsalesview.Line3.backgroundColor = UIColor.systemPink
            addsalesview.Line4.backgroundColor = UIColor.lightGray
            menu.hide()
        }
        else {
            addsalesview.Line1.backgroundColor = UIColor.lightGray
            addsalesview.Line2.backgroundColor = UIColor.lightGray
            addsalesview.Line3.backgroundColor = UIColor.lightGray
            addsalesview.Line4.backgroundColor = UIColor.systemPink
            MakeDropDown(x:2)
            menu.show()
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == addsalesview.CustomerNameTextField {
            addsalesview.NoteNumberTextField.becomeFirstResponder()
            menu.hide()
        }
        else if textField == addsalesview.NoteNumberTextField {
            addsalesview.NoteTextField.becomeFirstResponder()
        }
        else if textField == addsalesview.NoteTextField {
            addsalesview.ProductNameTextField.becomeFirstResponder()
        }
        else {
            menu.hide()
        }
        return true
    }
}

extension AddSaleViewController: YCActionSheetDatePickerDelegate {
    
    func datePicker(selected date: Date) {
        
        let dateFromStringFormatter = DateFormatter()
        dateFromStringFormatter.dateFormat = "dd/MM/yyyy"
        let dateFromString = dateFromStringFormatter.string(from: date)
        
        addsalesview.DateButton.setTitle(dateFromString, for: .normal)
    }
    
    
}

extension AddSaleViewController: AddedProdcuts {
    
    func NewProduct(Name:String,Ammount:String,Price:String) {
        print("Picked Name: \(Name)")
        print("Picked Ammount: \(Ammount)")
        print("Picked Price: \(Price)")
        
        let ob = Products()
        ob.Name = Name
        ob.Ammount = Int(Ammount)
        ob.Price = Int(Price)
        ob.FinalPrice = Int( Int(Ammount)! * Int(Price)! )
        self.ProductsArr.append(ob)
        addsalesview.tableView.reloadData()
        
        addsalesview.TotalCountProductLabel.text = String( Int(addsalesview.TotalCountProductLabel.text!)! + 1 )
        addsalesview.TotalFinalPrice.text = String( Int(addsalesview.TotalFinalPrice.text!)! + (Int(Ammount)! * Int(Price)!) )
    }
    
}
