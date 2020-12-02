//
//  ViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 10/31/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func BTNSales (_ sender:Any) {
        Tools.openForm(MainViewName: "Main", FormID: "SalesView", ob: self)
    }
    
    @IBAction func BTNBuying (_ sender:Any) {
        Tools.openForm(MainViewName: "Main", FormID: "BuyingView", ob: self)
    }

}

