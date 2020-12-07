//
//  SalaryPageViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 12/6/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit

class SalaryPageViewController: UIViewController {
    
    var salarypageview: SalaryPageView! {
        guard isViewLoaded else { return nil }
        return (view as! SalaryPageView)
    }
    
    var screenedge : UIScreenEdgePanGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK:- TODO:- This Line for adding Geusters.
        screenedge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(Back(_:)))
        screenedge.edges = .left
        view.addGestureRecognizer(screenedge)

        LoadData()
    }
    
    @IBAction func BTNBack (_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BTNAdd (_ sender: Any) {
        
        let alert = UIAlertController(title: "انتبه", message: "نوع السند؟", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "قبض", style: .default, handler: { (alert) in
            
            // Open New Form And Send Status = true
            let vc = UIStoryboard(name: "Main", bundle: nil)
            let next = vc.instantiateViewController(withIdentifier: "Earns Page") as! EarnsPageViewController
            next.modalPresentationStyle = .fullScreen
            next.Status = true
            self.present(next, animated: true, completion: nil)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "صرف", style: .default, handler: { (alert) in
            
            // Open New Form And Send Status = false
            let vc = UIStoryboard(name: "Main", bundle: nil)
            let next = vc.instantiateViewController(withIdentifier: "Earns Page") as! EarnsPageViewController
            next.modalPresentationStyle = .fullScreen
            next.Status = false
            self.present(next, animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func LoadData() {
        salarypageview.tableView.isHidden = true
        salarypageview.MessView.isHidden = false
    }
    
    // MARK:- TODO:- This Method For Add GuesterAction
    @objc func Back (_ sender:UIScreenEdgePanGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}
