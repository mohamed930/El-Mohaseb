//
//  EarnsPageViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 12/6/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import YCActionSheetDatePicker

class EarnsPageViewController: UIViewController {
    
    var earnspageview: EarnsPageView! {
        guard isViewLoaded else { return nil }
        return (view as! EarnsPageView)
    }
    
    var screenedge : UIScreenEdgePanGestureRecognizer!
    var Status = Bool()
    var type = String()
    var CurrentDate: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        Tools.MakeViewLine(view: earnspageview.View1)
        Tools.MakeViewLine(view: earnspageview.View2)
        
        // MARK:- TODO:- This Line for adding Geusters.
        screenedge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(Back(_:)))
        screenedge.edges = .left
        view.addGestureRecognizer(screenedge)
        
        ChangeStatus()
    }
    
    // MARK:- TODO:- Function Button Back.
    @IBAction func BTNBack (_ sender: Any) {
        ActionBack(x: 1)
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
    
    // MARK:- TODO:- This Method For Show if he wanna to know save or not.
    func ActionBack (x:Int) {
        let Alert = UIAlertController(title: "تاكيد", message: "هل تريد الحفظ؟", preferredStyle: .alert)
        
        Alert.addAction(UIAlertAction(title: "لا", style: .default, handler: {(alert) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        Alert.addAction(UIAlertAction(title: "نعم", style: .default, handler: { (alert) in
            
            // MARK:- TODO:- Make Method Call SaveFullTableData To Save Data To Database.
            print("Saved!")
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(Alert, animated: true, completion: nil)
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
