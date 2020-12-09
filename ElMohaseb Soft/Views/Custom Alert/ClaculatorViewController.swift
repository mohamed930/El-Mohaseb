//
//  ClaculatorViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 12/6/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import ProgressHUD

protocol popupCalculator {
    func Back(X:String)
}

class ClaculatorViewController: UIViewController {
    
    var delegate: popupCalculator!
    @IBOutlet weak var textField: UILabel!
    @IBOutlet weak var Button7: UIButton!
    @IBOutlet weak var Button8: UIButton!
    @IBOutlet weak var Button9: UIButton!
    @IBOutlet weak var ButtonDel: UIButton!
    @IBOutlet weak var Button4: UIButton!
    @IBOutlet weak var Button5: UIButton!
    @IBOutlet weak var Button6: UIButton!
    @IBOutlet weak var ButtonMul: UIButton!
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var ButtonMinus: UIButton!
    @IBOutlet weak var ButtonDot: UIButton!
    @IBOutlet weak var Button0: UIButton!
    @IBOutlet weak var ButtonC: UIButton!
    @IBOutlet weak var ButtonPlus: UIButton!
    @IBOutlet weak var ButtonOk: UIButton!
    @IBOutlet weak var ButtonDiv: UIButton!
    @IBOutlet weak var ButtonEqual: UIButton!
    
    var Number1 = Double()
    var Number2 = Double()
    var operation: Character?

    override func viewDidLoad() {
        super.viewDidLoad()

        MakeViewLine(view: Button7)
        MakeViewLine(view: Button8)
        MakeViewLine(view: Button9)
        MakeViewLine(view: ButtonDel)
        MakeViewLine(view: Button4)
        MakeViewLine(view: Button5)
        MakeViewLine(view: Button6)
        MakeViewLine(view: ButtonMul)
        MakeViewLine(view: Button1)
        MakeViewLine(view: Button2)
        MakeViewLine(view: Button3)
        MakeViewLine(view: ButtonMinus)
        MakeViewLine(view: ButtonDot)
        MakeViewLine(view: ButtonC)
        MakeViewLine(view: ButtonPlus)
        MakeViewLine(view: ButtonOk)
        MakeViewLine(view: ButtonDiv)
        MakeViewLine(view: ButtonEqual)
    }
    
    func MakeViewLine (view:UIButton) {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor().hexStringToUIColor(hex: "#CECECE").cgColor
        view.layer.masksToBounds = true
    }
    
    func SetText(number:String) {
        self.textField.text = self.textField.text! + number
    }
    
    @IBAction func ButtonAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            SetText(number: "7")
            break
        case 2:
            SetText(number: "8")
            break
        case 3:
            SetText(number: "9")
            break
        case 4:
            SetText(number: "4")
            break
        case 5:
            SetText(number: "5")
            break
        case 6:
            SetText(number: "6")
            break
        case 7:
            SetText(number: "1")
            break
        case 8:
            SetText(number: "2")
            break
        case 9:
            SetText(number: "3")
            break
        case 10:
            SetText(number: ".")
            break
        case 11:
            SetText(number: "0")
            break
        case 12:
            Number1 = 0.0
            Number2 = 0.0
            operation = nil
            self.textField.text = ""
            break
        case 13:
            Number1 = Double(self.textField.text!)!
            self.operation = "*"
            self.textField.text = ""
            break
        case 14:
            Number1 = Double(self.textField.text!)!
            self.operation = "-"
            self.textField.text = ""
            break
        case 15:
            Number1 = Double(self.textField.text!)!
            self.operation = "+"
            self.textField.text = ""
            break
        case 16:
            Number1 = Double(self.textField.text!)!
            self.operation = "/"
            self.textField.text = ""
            break
        default:
            print("Error")
        }
        
    }
    
    
    @IBAction func DeleteButton(_ sender: Any) {
        self.textField.text = (self.textField.text!.subString(from: 0, to: self.textField.text!.count - 2))
    }
    
    
    @IBAction func OkButton(_ sender: Any) {
        self.delegate.Back(X: (self.textField.text!))
    }
    
    
    @IBAction func EqualButton(_ sender: Any) {
        switch operation {
        case "*":
            Number2 = Double(self.textField.text!)!
            self.textField.text = String(self.Number1 * self.Number2)
            break
        case "-":
            Number2 = Double(self.textField.text!)!
            self.textField.text = String(self.Number1 - self.Number2)
            break
        case "+":
            Number2 = Double(self.textField.text!)!
            self.textField.text = String(self.Number1 + self.Number2)
            break
        case "/":
            Number2 = Double(self.textField.text!)!
            self.textField.text = String(self.Number1 / self.Number2)
        case nil:
            ProgressHUD.showError("Please Pick operation")
            break
        default:
            print("Error")
        }
    }
    
}

extension String {
    func subString(from: Int, to: Int) -> String {
       let startIndex = self.index(self.startIndex, offsetBy: from)
       let endIndex = self.index(self.startIndex, offsetBy: to)
       return String(self[startIndex...endIndex])
    }
}
