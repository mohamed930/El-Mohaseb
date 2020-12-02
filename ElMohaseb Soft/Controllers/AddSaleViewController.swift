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
import FirebaseAuth
import FirebaseFirestore
import RappleProgressHUD
import ProgressHUD

protocol ReloadData {
    func Reload (X:Int)
}

class AddSaleViewController: UIViewController {
    
    var screenedge : UIScreenEdgePanGestureRecognizer!
    var menu:DropDown!
    var ProductsArr = Array<Products>()
    var GetProductsArr = Array<Products>()
    var AmmountsArr = Array<AmmountProducts>()
    var Names = [""]
    var customers = [""]
    var F = 0
    var CurrentDate = ""
    var delegate: ReloadData!
    var Flag = false
    var ProductID: String?
    var ProductName:String?
    var ProductAmmount:String?
    var ProductPrice:String?
    var OldProductAmmout: String?
    var ProductId = ""
    var Picked = false
    var ReseteId:String?
    var FinalAmmount = ""
    var AmmountBeforeChanged = ""
    var ShowedMenyFlag = false
    var ReseteTotalPrice: String?
    
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
        
        if Flag == false {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let result = formatter.string(from: date)
            CurrentDate = result
            addsalesview.DateButton.setTitle(CurrentDate, for: .normal)
            
            FillData()
        }
        else {
            GetReseteData()
        }
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
                    // Fill All
                    for i in 0...(self.GetProductsArr.count - 1) {
                        if GetProductsArr[i].Name == self.addsalesview.ProductNameTextField.text! {
                            vc.PicekdID       = GetProductsArr[i].Id!
                            vc.ProductPrice   = String(GetProductsArr[i].Price!)
                            vc.ProductAmmount = String(GetProductsArr[i].Ammount!)
                            vc.TotalPrice = String( GetProductsArr[i].Price! * GetProductsArr[i].Ammount! )
                        }
                    }
                    vc.delegate = self
                }
                else if F == 3 {
                    vc.Flag = "2"
                    vc.ProductcName = self.ProductName
                    vc.NewProductAmmout = self.ProductAmmount
                    vc.ProductPrice = self.ProductPrice
                    vc.ProductAmmount = self.OldProductAmmout
                    vc.PicekdID = self.ProductId
                    vc.delegate = self
                }
            }
        }
    }
    
    private func createActionSheetDatePicker() -> YCActionSheetDatePickerVC {
        let vc = YCActionSheetDatePickerVC()
        vc.datePickerView.datePicker.datePickerMode = UIDatePicker.Mode.date
        vc.datePickerView.contentViewInsets = .zero
        vc.delegate = self
        return vc
    }
    
    // MARK:- TODO:- Make Function To Fill Products.
    func FillData () {
        
        Names.removeAll()
        customers.removeAll()
        
        RappleActivityIndicatorView.startAnimatingWithLabel("loading", attributes: RappleModernAttributes)
        
        Firebase.publicreadWithWhereCondtion(collectionName: "Products", key: "EmailID", value: (Auth.auth().currentUser?.email!)!) { (query) in
            
             for q in query.documents {
                let ob = Products()
                ob.Name = (q.get("ProductName") as! String)
                ob.Ammount = Int ((q.get("Ammount") as! String))
                ob.Price = Int ((q.get("Price") as! String))
                ob.FinalPrice = Int ((q.get("TotalPrice") as! String))
                ob.Notes = (q.get("Notes") as! String)
                ob.Id = (q.documentID)
                self.GetProductsArr.append(ob)
                self.Names.append(q.get("ProductName") as! String)
            }
            
        }
        
        Firebase.publicreadWithWhereCondtion(collectionName: "resete", key: "EmailID", value: (Auth.auth().currentUser?.email)!) { (snapshot) in
            
            for q in snapshot.documents {
                self.customers.append((q.get("CustomerName") as! String))
            }
            RappleActivityIndicatorView.stopAnimation()
        }
    }
    
    // MARK:- TODO:- DropDown Menu Action.
    func MakeDropDown(x:Int) {
        
        switch(x) {
        case 1:
            SetMenuIntialize(ArrayData: customers , PrintedTextField: addsalesview.CustomerNameTextField)
            break
        case 2:
            if self.Flag == true {
                
                var ProductsNames = [""]
                
                ProductsNames.removeAll()
                for i in 0...(self.ProductsArr.count - 1) {
                    ProductsNames.append(self.ProductsArr[i].Name!)
                }
                
                let result = Set(Names).symmetricDifference(ProductsNames)
                
                menu = {
                    let menu = DropDown()
                    menu.dataSource = Array(result)
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
            }
            else if Flag == false {
                menu = {
                    let menu = DropDown()
                    menu.dataSource = Names
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
            
            // MARK:- TODO:- Make Method Call SaveFullTableData To Save Data To Database.
            self.SaveFullTableData(x: 0)
            
        }))
        
        self.present(Alert, animated: true, completion: nil)
    }
    
    // MARK:- TODO:- function SaveFullTableData.
    func SaveFullTableData(x:Int) {
        
        if (x == 1) {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            
            if Flag == true {
                // Update Data
                print ("Updated!")
                UpdateResete()
            }
            else {
                if (self.addsalesview.CustomerNameTextField.text == "" || self.addsalesview.NoteNumberTextField.text == "") {
                    Tools.createAlert(Title: "Error", Mess: "Please Fill All Fields", ob: self)
                }
                else {
                    
                    let id = UUID()
                    let ReseteData = ["CustomerName":self.addsalesview.CustomerNameTextField.text! as Any,
                                      "ReseteNumber": self.addsalesview.NoteNumberTextField.text! as Any,
                                      "Notes": self.addsalesview.NoteTextField.text! as Any,
                                      "TotalNumberProducts": self.addsalesview.TotalCountProductLabel.text! as Any,
                                      "TotalPrices": self.addsalesview.TotalFinalPrice.text!,
                                      "Date": self.CurrentDate,
                                      "EmailID": Auth.auth().currentUser?.email! as Any,
                                      "ProductsID": id.uuidString
                                    ]
                    
                    RappleActivityIndicatorView.startAnimatingWithLabel("loading", attributes: RappleModernAttributes)
                    
                    Firestore.firestore().collection("resete").document(id.uuidString).setData(ReseteData) {
                        error in
                        
                        if error != nil {
                            RappleActivityIndicatorView.stopAnimation()
                            ProgressHUD.showError("Error in your connection")
                        }
                        else {
                            
                            for i in 0...(self.ProductsArr.count - 1) {
                                
                                let ProductsData = ["ProductName": self.ProductsArr[i].Name!,
                                                    "AmmountProduct": self.ProductsArr[i].Ammount!,
                                                    "PriceProduct": self.ProductsArr[i].Price!,
                                                    "TotalPrice": self.ProductsArr[i].FinalPrice!,
                                                    "ReseteID": id.uuidString
                                                   ] as [String : Any]
                                Firestore.firestore().collection("SoldProducts").document().setData(ProductsData) {
                                    error in
                                    if error != nil {
                                       RappleActivityIndicatorView.stopAnimation()
                                       ProgressHUD.showError("Error in your connection")
                                    }
                                    else {
                                        
                                        Firestore.firestore().collection("Products").document(self.ProductsArr[i].Id!).getDocument { (query, error) in
                                            if error != nil {
                                               RappleActivityIndicatorView.stopAnimation()
                                               ProgressHUD.showError("Error in your connection")
                                            }
                                            else {
                                                
                                                let data = ["Ammount": String(Int(query?.get("Ammount") as! String)! - self.ProductsArr[i].Ammount!)]
                                                
                                                Firestore.firestore().collection("Products").document(self.ProductsArr[i].Id!).updateData(data) {
                                                    error in
                                                    if error != nil {
                                                       RappleActivityIndicatorView.stopAnimation()
                                                       ProgressHUD.showError("Error in your connection")
                                                    }
                                                    else {
                                                        if i == (self.ProductsArr.count - 1) {
                                                            RappleActivityIndicatorView.stopAnimation()
                                                            ProgressHUD.showSuccess("Success Resete Added!")
                                                            self.delegate.Reload(X: 1)
                                                            self.dismiss(animated: true, completion: nil)
                                                        }
                                                    }
                                                }
                                                
                                            }
                                        }
                                        
                                    }
                                }
                            }
                            
                        }
                        
                    }
                    
                }
            }
            
            
        }
        
    }
    
    // MARK:- TODO:- function GetReseteData to Edit it.
    func GetReseteData() {
        Names.removeAll()
        customers.removeAll()
        
        RappleActivityIndicatorView.startAnimatingWithLabel("loading", attributes: RappleModernAttributes)
        
        Firebase.publicreadWithWhereCondtion(collectionName: "resete", key: "EmailID", value: (Auth.auth().currentUser?.email)!) { (snapshot) in
            
            for q in snapshot.documents {
                self.customers.append((q.get("CustomerName") as! String))
            }
            //RappleActivityIndicatorView.stopAnimation()
        }
        
         Firebase.publicreadWithWhereCondtion(collectionName: "Products", key: "EmailID", value: (Auth.auth().currentUser?.email!)!) { (query) in
            for q in query.documents {
                let ob = Products()
                ob.Name = (q.get("ProductName") as! String)
                ob.Ammount = Int ((q.get("Ammount") as! String))
                ob.Price = Int ((q.get("Price") as! String))
                ob.FinalPrice = Int ((q.get("TotalPrice") as! String))
                ob.Notes = (q.get("Notes") as! String)
                ob.Id = (q.documentID)
                self.GetProductsArr.append(ob)
                self.Names.append(q.get("ProductName") as! String)
            }
        }
        
        //print("Success ID is: \(AddSaleViewController.ProductID!)")
        
        Firebase.publicreadWithWhereCondtion(collectionName: "resete", key: "ProductsID", value: ProductID!) { (query) in
            
            for q in query.documents {
                self.addsalesview.CustomerNameTextField.text = (q.get("CustomerName") as! String)
                self.addsalesview.NoteNumberTextField.text = (q.get("ReseteNumber") as! String)
                self.addsalesview.NoteTextField.text = (q.get("Notes") as! String)
                self.addsalesview.DateButton.setTitle((q.get("Date") as! String), for: .normal)
                self.CurrentDate = (q.get("Date") as! String)
                self.addsalesview.TotalCountProductLabel.text = (q.get("TotalNumberProducts") as! String)
                self.addsalesview.TotalFinalPrice.text = (q.get("TotalPrices") as! String)
                
                // Add Price and count to var.
                self.ReseteTotalPrice = ((q.get("TotalPrices") as! String))
                
                self.ReseteId = q.documentID
            }
            
            Firebase.publicreadWithWhereCondtion(collectionName: "SoldProducts", key: "ReseteID", value: self.ProductID!) { (snap) in
                
                for doc in snap.documents {
                    let ob = Products()
                    ob.Name = (doc.get("ProductName") as! String)
                    ob.Price = (doc.get("PriceProduct") as! Int)
                    ob.Ammount = (doc.get("AmmountProduct") as! Int)
                    ob.FinalPrice = (doc.get("TotalPrice") as! Int)
                    ob.Id = doc.documentID
                    ob.status = "Old"
                    self.ProductsArr.append(ob)
                    self.addsalesview.tableView.reloadData()
                }
                self.MakeDropDown(x:2)
                RappleActivityIndicatorView.stopAnimation()
                
            }
            
        }
    }
    
    // MARK:- TODO:- function Update Resete Data.
    func UpdateResete() {
        
//        for i in 0...(self.ProductsArr.count - 1) {
//
//            print("ProductName: \(self.ProductsArr[i].Name!), ProductFlag: \(self.ProductsArr[i].status)")
//        }
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading", attributes: RappleModernAttributes)
        
        let ReseteData = ["CustomerName":self.addsalesview.CustomerNameTextField.text! as Any,
                          "ReseteNumber": self.addsalesview.NoteNumberTextField.text! as Any,
                          "Notes": self.addsalesview.NoteTextField.text! as Any,
                          "TotalNumberProducts": self.addsalesview.TotalCountProductLabel.text! as Any,
                          "TotalPrices": self.addsalesview.TotalFinalPrice.text!,
                          "Date": self.CurrentDate,
                          "EmailID": Auth.auth().currentUser?.email! as Any
                          ]
        
        Firebase.updateDocumnt(collectionName: "resete", documntId: self.ReseteId! , data: ReseteData) { (result) in
            if result == "Success" {
                
                if self.ReseteTotalPrice == self.addsalesview.TotalFinalPrice.text! {
                    
                    // Finish The Update here.
                    RappleActivityIndicatorView.stopAnimation()
                    ProgressHUD.showSuccess("Success Resete Added!")
                    self.delegate.Reload(X: 1)
                    self.dismiss(animated: true, completion: nil)
                    
                }
                else {
                    // Update Sold Products.
                    for i in 0...(self.ProductsArr.count - 1) {
                        
                        //print("ProductName: \(self.ProductsArr[i].Name!), ProductFlag: \(self.ProductsArr[i].status!)")
                    
                    let ProductsData = ["ProductName": self.ProductsArr[i].Name!,
                                        "AmmountProduct": self.ProductsArr[i].Ammount!,
                                        "PriceProduct": self.ProductsArr[i].Price!,
                                        "TotalPrice": self.ProductsArr[i].FinalPrice!,
                                        "ReseteID": self.ReseteId!
                                       ] as [String : Any]
                        
                        if self.ProductsArr[i].status == "Old" {
                            
                            // Update Data.
                            // ----------------------------
                            Firestore.firestore().collection("SoldProducts").document(self.ProductsArr[i].Id!).setData(ProductsData) {
                                error in
                                if error != nil {
                                   RappleActivityIndicatorView.stopAnimation()
                                   ProgressHUD.showError("Error in your connection")
                                }
                                else {
                                    
                                    Firestore.firestore().collection("Products").whereField("EmailID", isEqualTo: (Auth.auth().currentUser?.email)!).getDocuments { (q, error) in
                                        if error != nil {
                                            RappleActivityIndicatorView.stopAnimation()
                                        }
                                        else {
                                            for f in q!.documents {
                                                
                                                if self.ProductsArr[i].Name! == f.get("ProductName") as! String {
                                                    
                                                    let ProductID = f.documentID
                                                    
                                                    let OldAmmount = (f.get("Ammount") as! String)
                                                    print("F: \(Int(OldAmmount)!)")
                                                    
                                                    if self.ProductsArr[i].status == "Old" {
                                                        
                                                        for j in stride(from: 0, to: (self.AmmountsArr.count), by: 1) {
                                                                                                               
                                                           for n in 0...(self.ProductsArr.count - 1) {
                                                               if self.AmmountsArr[j].Id! == self.ProductsArr[n].Id! {
                                                                   self.AmmountBeforeChanged = self.AmmountsArr[j].OldAmount!
                                                                   break
                                                               }
                                                           }
                                                           
                                                           if self.AmmountsArr[j].Id! == self.ProductsArr[i].Id! {
                                                               
                                                               self.FinalAmmount = String( Int(Int(OldAmmount)! + Int(self.AmmountBeforeChanged)!) - (self.ProductsArr[i].Ammount!) )
                                                               
                                                               let data = ["Ammount": self.FinalAmmount]
                                                               
                                                               Firestore.firestore().collection("Products").document(ProductID).updateData(data) {
                                                                   error in
                                                                   if error != nil {
                                                                      RappleActivityIndicatorView.stopAnimation()
                                                                      ProgressHUD.showError("Error in your connection")
                                                                   }
                                                                   else {
                                                                       if i == (self.ProductsArr.count - 1) {
                                                                           RappleActivityIndicatorView.stopAnimation()
                                                                           ProgressHUD.showSuccess("Success Resete Added!")
                                                                           self.delegate.Reload(X: 1)
                                                                           self.dismiss(animated: true, completion: nil)
                                                                       }
                                                                   }
                                                               }
                                                               
                                                           }
                                                        
                                                       }
                                                    }
                                                    
                                                   
                                                    
                                                    
                                                }
                                                else {
                                                    continue
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                            
                            }
                            // ----------------------------
                            
                        }
                        
                        else if self.ProductsArr[i].status == "New" {
                            
                            // Add Data on Resete.
                            // -------------------------------
                            Firestore.firestore().collection("SoldProducts").document().setData(ProductsData) {
                                error in
                                if error != nil {
                                   RappleActivityIndicatorView.stopAnimation()
                                   ProgressHUD.showError("Error in your connection")
                                }
                                else {
                                    
                                    // Update Products.
                                    // -----------------------
                                    Firestore.firestore().collection("Products").document(self.ProductsArr[i].Id!).getDocument { (query, error) in
                                        if error != nil {
                                            RappleActivityIndicatorView.stopAnimation()
                                            ProgressHUD.showError("Error in your connection")
                                        }
                                        else {
                                            
                                            let data = ["Ammount": String(Int(query?.get("Ammount") as! String)! - self.ProductsArr[i].Ammount!)]
                                            
                                            Firestore.firestore().collection("Products").document(self.ProductsArr[i].Id!).updateData(data) {
                                                error in
                                                if error != nil {
                                                    RappleActivityIndicatorView.stopAnimation()
                                                    ProgressHUD.showError("Error in your connection")
                                                }
                                                else {
                                                    if i == (self.ProductsArr.count - 1) {
                                                        RappleActivityIndicatorView.stopAnimation()
                                                        ProgressHUD.showSuccess("Success Resete Added!")
                                                        self.delegate.Reload(X: 1)
                                                        self.dismiss(animated: true, completion: nil)
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                    // -----------------------
                                
                                }
                            
                            }
                            // -------------------------------
                            
                        }
                        
                    }
                }
            }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if Flag == true {
            
            //self.ProductId = self.ProductsArr[indexPath.row].Id!
            
            //print("Suecess: \(self.ProductId)")
            
            self.F = 3
            self.Picked = true
            self.ProductAmmount = String(self.ProductsArr[indexPath.row].Ammount!)
            self.ProductName = self.ProductsArr[indexPath.row].Name!
            self.ProductId = self.ProductsArr[indexPath.row].Id!
            
            Firebase.publicreadWithWhereCondtion(collectionName: "Products", key: "EmailID", value: (Auth.auth().currentUser?.email!)!) { (snap) in
                for q in snap.documents {
                    if ((q.get("ProductName") as! String) == self.ProductsArr[indexPath.row].Name!) {
                        RappleActivityIndicatorView.stopAnimation()
                        self.ProductPrice   = (q.get("Price") as! String)
                        self.OldProductAmmout = (q.get("Ammount") as! String)
                        self.performSegue(withIdentifier: "AddProduct", sender: self)
                        break
                    }
                    else {
                        continue
                    }
                }
            }
        }
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
            ShowedMenyFlag = true
            menu.show()
        }
        else if textField.tag == 2 {
            addsalesview.Line1.backgroundColor = UIColor.lightGray
            addsalesview.Line2.backgroundColor = UIColor.systemPink
            addsalesview.Line3.backgroundColor = UIColor.lightGray
            addsalesview.Line4.backgroundColor = UIColor.lightGray
            if ShowedMenyFlag == true {
                menu.hide()
            }
        }
        else if textField.tag == 3 {
            addsalesview.Line1.backgroundColor = UIColor.lightGray
            addsalesview.Line2.backgroundColor = UIColor.lightGray
            addsalesview.Line3.backgroundColor = UIColor.systemPink
            addsalesview.Line4.backgroundColor = UIColor.lightGray
            if ShowedMenyFlag == true {
                menu.hide()
            }
        }
        else {
            addsalesview.Line1.backgroundColor = UIColor.lightGray
            addsalesview.Line2.backgroundColor = UIColor.lightGray
            addsalesview.Line3.backgroundColor = UIColor.lightGray
            addsalesview.Line4.backgroundColor = UIColor.systemPink
            if Flag == false {
                self.MakeDropDown(x:2)
            }
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
        
        self.CurrentDate = dateFromString
        addsalesview.DateButton.setTitle(dateFromString, for: .normal)
    }
    
    
}

extension AddSaleViewController: AddedProdcuts {
    
    func AmmountBeforeEdit(Id:String ,Ammount: String) {
        
        if F == 3  && Picked == true {
            print("Ammount Before Changed: \(Ammount)")
            
            let o = AmmountProducts()
            o.Id = Id
            o.OldAmount = Ammount
            self.AmmountsArr.append(o)
        }
        else {
            print("0")
        }
    }
    
    
    func NewProduct(Name:String,Ammount:String,Price:String,Id:String) {
        
        // Update Current Product And Add it To table after replace old Data.
        if F == 3  && Picked == true {
            print("Picked Name: \(Name)")
            print("Picked Ammount: \(Ammount)")
            print("Picked Price: \(Price)")
            print("ProductID: \(Id)")
            
            //var Flag = false
            
            for i in 0...(ProductsArr.count - 1) {
                if ProductsArr[i].Id == Id {
                    ProductsArr.remove(at: i)
                    let ob = Products()
                    ob.Name = Name
                    ob.Ammount = Int(Ammount)
                    ob.Price = Int(Price)
                    ob.FinalPrice = Int( Int(Ammount)! * Int(Price)! )
                    ob.Id = Id
                    ob.status = "Old"
                    self.ProductsArr.append(ob)
                    addsalesview.tableView.reloadData()
                    //Flag = true
                    break
                }
                else {
                    continue
                }
            }
            
            // Get Array Count
            self.addsalesview.TotalCountProductLabel.text = String(self.ProductsArr.count)
            
            // Add New Final Price.
            var FinalPrice = 0
            for i in 0...(ProductsArr.count - 1) {
                FinalPrice += ProductsArr[i].FinalPrice!
            }
            addsalesview.TotalFinalPrice.text = String(FinalPrice)
        }
        // For Add Products
        else if Picked == false || F <= 3 {
            print("Picked Name: \(Name)")
            print("Picked Ammount: \(Ammount)")
            print("Picked Price: \(Price)")
            print("ProductID: \(Id)")
            
            let ob = Products()
            ob.Name = Name
            ob.Ammount = Int(Ammount)
            ob.Price = Int(Price)
            ob.FinalPrice = Int( Int(Ammount)! * Int(Price)! )
            ob.Id = Id
            ob.status = "New"
            self.ProductsArr.append(ob)
            addsalesview.tableView.reloadData()
            
            addsalesview.TotalCountProductLabel.text = String( Int(addsalesview.TotalCountProductLabel.text!)! + 1 )
            addsalesview.TotalFinalPrice.text = String( Int(addsalesview.TotalFinalPrice.text!)! + (Int(Ammount)! * Int(Price)!) )
        }
    }
    
    
    
}
