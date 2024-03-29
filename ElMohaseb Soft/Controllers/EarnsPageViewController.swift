//
//  EarnsPageViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 12/6/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import YCActionSheetDatePicker
import RappleProgressHUD
import Firebase
import FirebaseAuth
import FirebaseFirestore
import ProgressHUD

protocol SendChange {
    func ReloadData (X:Bool)
}

class EarnsPageViewController: UIViewController {
    
    var earnspageview: EarnsPageView! {
        guard isViewLoaded else { return nil }
        return (view as! EarnsPageView)
    }
    
    var screenedge : UIScreenEdgePanGestureRecognizer!
    var Status = Bool()
    var type = String()
    var CurrentDate: String?
    var Action = false
    var delegate: SendChange?
    var PickedResete: Earns?
    
    var ColumnArray = Array<Cashing>()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        Tools.MakeViewLine(view: earnspageview.View1)
        Tools.MakeViewLine(view: earnspageview.View2)
        
        earnspageview.tableView.register(UINib(nibName: "EarnsCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        // MARK:- TODO:- This Line for adding Geusters.
        screenedge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(Back(_:)))
        screenedge.edges = .left
        view.addGestureRecognizer(screenedge)
        
        if Action == true {
            GetDate()
        }
        else {
            ChangeStatus()
        }
    }
    
    // MARK:- TODO:- Function Button Back.
    @IBAction func BTNBack (_ sender: Any) {
        ActionBack(x: 1)
    }
    
    @IBAction func BTNSave (_ sender:Any) {
        if Action == false {
            Save()
        }
        else {
            update()
        }
    }
    
    @IBAction func switchButtonChanged (sender: UISwitch) {
        if sender.isOn == true {
            earnspageview.TitleLabel.text = "سند صرف"
            earnspageview.TypeLabel.text = "صرف"
            type = "Cash"
        }
        else {
            earnspageview.TitleLabel.text = "سند قبض"
            earnspageview.TypeLabel.text = "قبض"
            type = "Earns"
        }
    }
    
    @IBAction func BTNAdd (_ sender:Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil)
        let next = vc.instantiateViewController(withIdentifier: "Earns Price") as! EarnsPriceViewController
        next.NewFlag = true
        next.delegate = self
        self.present(next, animated: true, completion: nil)
        
    }
    
    // MARK:- TODO:- Fucntion Show Date To Pickit.
    @IBAction func BTNShowData (_ sender:Any) {
        present(createActionSheetDatePicker(), animated: true, completion: nil)
    }
    
    // MARK:- TODO:- Thid Method For LoadPage.
    func ChangeStatus () {
        if Status == false {
            
            // Make Page Cashing
            earnspageview.TypeSwitch.setOn(true, animated: true)
            earnspageview.TitleLabel.text = "سند صرف"
            earnspageview.TypeLabel.text = "صرف"
            type = "Cash"
            
        }
        else if Status == true {
            
            // Make Page Earns
            earnspageview.TypeSwitch.setOn(false, animated: true)
            earnspageview.TitleLabel.text = "سند قبض"
            earnspageview.TypeLabel.text = "قبض"
            type = "Earns"
            
        }
    }
    
    // MARK:- TODO:- Load Resete Data.
    func GetDate () {
        
        RappleActivityIndicatorView.startAnimatingWithLabel("loading", attributes: RappleModernAttributes)
        self.earnspageview.NumberTextField.text = String(self.PickedResete!.Number)
        self.earnspageview.NoteTextField.text = self.PickedResete!.Note
        self.earnspageview.DateButton.setTitle(self.PickedResete!.Date , for: .normal)
        self.earnspageview.TotalLabel.text = self.PickedResete!.Total
        self.earnspageview.TypeLabel.text = self.PickedResete!.type
        
        if self.PickedResete!.type == "قبض" {
            self.type = "Earns"
        }
        else {
            self.type = "Cash"
        }
        
        Firebase.publicreadWithWhereCondtion(collectionName: "EarnsElements", key: "ReseteID", value: self.PickedResete!.ID) { (snapsot) in
            for i in snapsot.documents {
                let ob = Cashing()
                ob.Name = (i.get("Title") as! String)
                ob.price = (i.get("Price") as! Double)
                ob.Note = (i.get("Note") as! String)
                self.ColumnArray.append(ob)
                self.earnspageview.tableView.reloadData()
            }
            RappleActivityIndicatorView.stopAnimation()
        }
    }
    
    // MARK:- TODO:- This Method For Show if he wanna to know save or not.
    func ActionBack (x:Int) {
        let Alert = UIAlertController(title: "تاكيد", message: "هل تريد الحفظ؟", preferredStyle: .alert)
        
        Alert.addAction(UIAlertAction(title: "لا", style: .default, handler: {(alert) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        Alert.addAction(UIAlertAction(title: "نعم", style: .default, handler: { (alert) in
            
            // MARK:- TODO:- Make Method Call SaveFullTableData To Save Data To Database.
            print("Saved!")
            if self.Action == false {
                self.Save()
            }
            else {
                self.update()
            }
            
            
        }))
        
        self.present(Alert, animated: true, completion: nil)
    }
    
    func Save() {
        print(self.type)
        RappleActivityIndicatorView.startAnimatingWithLabel("loading", attributes: RappleModernAttributes)
        
        let id = UUID()
        var data = [String:Any]()
        
        if self.type == "Earns" {
            data = [
                        "NumberOfResete": self.earnspageview.NumberTextField.text!,
                        "NoteOfResete": self.earnspageview.NoteTextField.text!,
                        "DateOfResete": self.CurrentDate!,
                        "EarnsID": id.uuidString,
                        "TotalResete": self.earnspageview.TotalLabel.text!,
                        "Type": "قبض",
                        "Target": "الصندوق",
                        "Currency": "محلي",
                        "UserName": (Auth.auth().currentUser?.email!)!
                   ] as [String:Any]
        }
        else if self.type == "Cash" {
            data = [
                        "NumberOfResete": self.earnspageview.NumberTextField.text!,
                        "NoteOfResete": self.earnspageview.NoteTextField.text!,
                        "DateOfResete": self.CurrentDate!,
                        "EarnsID": id.uuidString,
                        "TotalResete": self.earnspageview.TotalLabel.text!,
                        "Type": "صرف",
                        "Target": "الصندوق",
                        "Currency": "محلي",
                        "UserName": (Auth.auth().currentUser?.email!)!
                   ] as [String:Any]
        }
        
        Firebase.addData1(collectionName: "CashingResetes", documentID: id.uuidString, data: data) { (r) in
            if r == "Success" {
                
                // After Adding Resete Add Elements to EarnsElements
                for i in 0...(self.ColumnArray.count - 1) {
                    
                    let ColumnData = [
                                        "Title":self.ColumnArray[i].Name,
                                        "Price": self.ColumnArray[i].price,
                                        "Note": self.ColumnArray[i].Note ?? "",
                                        "ReseteID": id.uuidString
                                     ] as [String:Any]
                    
                    Firestore.firestore().collection("EarnsElements").document().setData(ColumnData) { (error) in
                        if error != nil {
                            RappleActivityIndicatorView.stopAnimation()
                            ProgressHUD.showError("Connection wasn't Estable")
                        }
                        else {
                            if  i == (self.ColumnArray.count - 1) {
                                RappleActivityIndicatorView.stopAnimation()
                                ProgressHUD.showSuccess("Added Successfully")
                                self.delegate?.ReloadData(X: true)
                                self.dismiss(animated: true, completion: nil)
                            }
                           
                        }
                    }
                    
                }
                
            }
        }
        
    }
    
    func update() {
        
        RappleActivityIndicatorView.startAnimatingWithLabel("loading", attributes: RappleModernAttributes)
        
        var data = [String:Any]()
        
        if self.type == "Earns" {
            data = [
                        "NumberOfResete": self.earnspageview.NumberTextField.text!,
                        "NoteOfResete": self.earnspageview.NoteTextField.text!,
                        "DateOfResete": self.CurrentDate!,
                        "TotalResete": self.earnspageview.TotalLabel.text!,
                        "Type": "قبض",
                        "Target": "الصندوق",
                        "Currency": "محلي",
                        "UserName": (Auth.auth().currentUser?.email!)!
                   ] as [String:Any]
        }
        else if self.type == "Cash" {
            data = [
                        "NumberOfResete": self.earnspageview.NumberTextField.text!,
                        "NoteOfResete": self.earnspageview.NoteTextField.text!,
                        "DateOfResete": self.CurrentDate!,
                        "TotalResete": self.earnspageview.TotalLabel.text!,
                        "Type": "صرف",
                        "Target": "الصندوق",
                        "Currency": "محلي",
                        "UserName": (Auth.auth().currentUser?.email!)!
                   ] as [String:Any]
        }
        
        Firebase.updateDocumnt(collectionName: "CashingResetes", documntId: self.PickedResete!.ID, data: data) { (result) in
            
            // He didn't Change Any Elemnts in resete.
            if self.earnspageview.TotalLabel.text == self.PickedResete?.Total {
                RappleActivityIndicatorView.stopAnimation()
                self.delegate?.ReloadData(X: true)
                self.dismiss(animated: true, completion: nil)
            }
            else {
                // Changed in Resete Element
                for i in 0...(self.ColumnArray.count - 1) {
                    
                    if self.ColumnArray[i].status == "Old" {
                        // Check if it's value changed or not.
                        
                    }
                    else {
                        // Addded To Resete ofcourse.
                        
                        let dataElement = [
                                            "Title":self.ColumnArray[i].Name,
                                            "Price": self.ColumnArray[i].price,
                                            "Note": self.ColumnArray[i].Note ?? "",
                                            "ReseteID": self.PickedResete!.ID
                                         ] as [String : Any]
                        
                        Firebase.addData1(collectionName: "EarnsElements", documentID: self.PickedResete!.ID, data: dataElement) { (q) in
                            if q == "Success" {
                                
                                if i == (self.ColumnArray.count - 1) {
                                    RappleActivityIndicatorView.stopAnimation()
                                    self.delegate?.ReloadData(X: true)
                                    self.dismiss(animated: true, completion: nil)
                                }
                                
                            }
                            else {
                                RappleActivityIndicatorView.stopAnimation()
                                ProgressHUD.showError("Error in your Connection!")
                            }
                        }
                    }
                    
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
    
    // MARK:- TODO:- This Method For Add GuesterAction
    @objc func Back (_ sender:UIScreenEdgePanGestureRecognizer) {
        ActionBack(x: 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension EarnsPageViewController: YCActionSheetDatePickerDelegate {
    
    func datePicker(selected date: Date) {
        
        let dateFromStringFormatter = DateFormatter()
        dateFromStringFormatter.dateFormat = "dd/MM/yyyy"
        let dateFromString = dateFromStringFormatter.string(from: date)
        
        self.CurrentDate = dateFromString
        earnspageview.DateButton.setTitle(dateFromString, for: .normal)
    }
    
    
}

extension EarnsPageViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == earnspageview.NumberTextField {
            earnspageview.NoteTextField.becomeFirstResponder()
        }
        else if textField == earnspageview.NoteTextField {
            earnspageview.TypeTextField.becomeFirstResponder()
        }
        else if textField == earnspageview.TypeTextField {
            self.view.endEditing(true)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            earnspageview.Line1.backgroundColor = UIColor.systemPink
            earnspageview.Line2.backgroundColor = UIColor.lightGray
            earnspageview.Line3.backgroundColor = UIColor.lightGray
        }
        else if textField.tag == 2 {
            earnspageview.Line1.backgroundColor = UIColor.lightGray
            earnspageview.Line2.backgroundColor = UIColor.systemPink
            earnspageview.Line3.backgroundColor = UIColor.lightGray
        }
        else if textField.tag == 3 {
            earnspageview.Line1.backgroundColor = UIColor.lightGray
            earnspageview.Line2.backgroundColor = UIColor.lightGray
            earnspageview.Line3.backgroundColor = UIColor.systemPink
        }
    }
}

extension EarnsPageViewController: UITableViewDelegate {
    
}

extension EarnsPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ColumnArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: EarnsCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EarnsCell
        
        cell.NameLabel.text = ColumnArray[indexPath.row].Name
        cell.PriceLabel.text = String(ColumnArray[indexPath.row].price)
        cell.NoteLabel.text = ColumnArray[indexPath.row].Note ?? ""
        
        return cell
        
    }
    
    
}

extension EarnsPageViewController: SendValue {
    
    func Send(Name: String, Price: String, Note: String) {
        
        let ob = Cashing()
        ob.Name = Name
        ob.price = Double(Price)!
        ob.Note = Note
        self.ColumnArray.append(ob)
        self.earnspageview.tableView.reloadData()
        
        self.earnspageview.TotalLabel.text = String(Double(self.earnspageview.TotalLabel.text!)! + Double(Price)!)
        
    }
}
