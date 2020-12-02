//
//  BuyingViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 11/28/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import ProgressHUD

class BuyingViewController: UIViewController {
    
    var screenedge : UIScreenEdgePanGestureRecognizer!
    
    var buyingview: BuyingView! {
        guard isViewLoaded else { return nil }
        return (view as! BuyingView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK:- TODO:- This Line for adding Geusters.
        screenedge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(Back(_:)))
        screenedge.edges = .left
        view.addGestureRecognizer(screenedge)
        
    }
    
    @IBAction func BTNBack(_ sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BTNAddBuying (_ sender:Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let next = story.instantiateViewController(withIdentifier: "AddBuyingView") as! AddBuyingViewController
        next.delegate = self
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
    }
    
    // MARK:- TODO:- This Method For Add GuesterAction
    @objc func Back (_ sender:UIScreenEdgePanGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension BuyingViewController: ReloadDataBuying {
    func Reload(X: Int) {
        if X == 1 {
            ProgressHUD.showSuccess("Added Sucessfully!")
        }
    }
    
    
}
