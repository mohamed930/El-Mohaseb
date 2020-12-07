//
//  EarnsPriceViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 12/6/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit

class EarnsPriceViewController: UIViewController {
    
    var earnspriceview: EarnsPriceView! {
        guard isViewLoaded else { return nil }
        return (view as! EarnsPriceView)
    }
    
    var NewFlag = Bool()
    var screenedge : UIScreenEdgePanGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK:- TODO:- This Line for adding Geusters.
        screenedge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(Back(_:)))
        screenedge.edges = .left
        view.addGestureRecognizer(screenedge)
        
        var tab = UITapGestureRecognizer()
        tab = UITapGestureRecognizer(target: self, action: #selector(gotoCairo(tapGestureRecognizer:)))
        tab.numberOfTapsRequired = 1
        tab.numberOfTouchesRequired = 1
        earnspriceview.CalculatorImage.isUserInteractionEnabled = true
        earnspriceview.CalculatorImage.addGestureRecognizer(tab)
        
        LoadData()
        
    }
    
    @IBAction func BTNClose(_ sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func gotoCairo(tapGestureRecognizer: UITapGestureRecognizer) {
        let calcPop: ClaculatorViewController = ClaculatorViewController(nibName: "ClaculatorViewController", bundle: nil)
        self.view.alpha = 1.0
        calcPop.delegate = self
        self.presentpopupViewController(popupViewController: calcPop, animationType: .TopBottom, completion: {() -> Void in })
    }
    
    @objc func Back (_ sender:UIScreenEdgePanGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func LoadData() {
        
        if NewFlag == false {
            // Get Product Name :- Price and note.
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension EarnsPriceViewController: popupCalculator {
    func Back() {
        self.dismissPopupViewController(animationType: .BottomBottom)
    }
    
    func Result(X:Double) {
        print("R: \(X)")
    }
    
    
}

extension EarnsPriceViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == earnspriceview.ProductName {
            earnspriceview.ProductPrice.becomeFirstResponder()
        }
        else if textField == earnspriceview.ProductPrice {
            earnspriceview.ProductNote.becomeFirstResponder()
        }
        else if textField == earnspriceview.ProductNote {
            self.view.endEditing(true)
            // Add Data to Firebase
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 1 {
            earnspriceview.Line1.backgroundColor = UIColor.systemPink
            earnspriceview.Line2.backgroundColor = UIColor.lightGray
            earnspriceview.Line3.backgroundColor = UIColor.lightGray
        }
        else if textField.tag == 2 {
            earnspriceview.Line1.backgroundColor = UIColor.lightGray
            earnspriceview.Line2.backgroundColor = UIColor.systemPink
            earnspriceview.Line3.backgroundColor = UIColor.lightGray
        }
        else if textField.tag == 3 {
            earnspriceview.Line1.backgroundColor = UIColor.lightGray
            earnspriceview.Line2.backgroundColor = UIColor.lightGray
            earnspriceview.Line3.backgroundColor = UIColor.systemPink
        }
    }
}
