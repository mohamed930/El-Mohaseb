//
//  ClaculatorViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 12/6/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
protocol popupCalculator {
    func Back()
    func Result(X:Double)
}

class ClaculatorViewController: UIViewController {
    
    var delegate: popupCalculator!
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
}
