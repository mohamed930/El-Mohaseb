//
//  SalaryPageViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 12/6/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import RappleProgressHUD

class SalaryPageViewController: UIViewController {
    
    var CashingArr = Array<Earns>()
    
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
        
        salarypageview.tableView.register(UINib(nibName: "CashingCell", bundle: nil), forCellReuseIdentifier: "Cell")

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
            next.delegate = self
            self.present(next, animated: true, completion: nil)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "صرف", style: .default, handler: { (alert) in
            
            // Open New Form And Send Status = false
            let vc = UIStoryboard(name: "Main", bundle: nil)
            let next = vc.instantiateViewController(withIdentifier: "Earns Page") as! EarnsPageViewController
            next.modalPresentationStyle = .fullScreen
            next.Status = false
            next.delegate = self
            self.present(next, animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true) {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        }
    }
    
    @objc func alertControllerBackgroundTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func LoadData() {
        /*salarypageview.tableView.isHidden = true
        salarypageview.MessView.isHidden = false*/
        
        Firebase.publicreadWithWhereCondtion(collectionName: "CashingResetes", key: "UserName", value: (Auth.auth().currentUser?.email!)!) { (snap) in
            
            if snap.count == 0 {
                self.salarypageview.tableView.isHidden = true
                self.salarypageview.MessView.isHidden = false
            }
            else {
                self.salarypageview.tableView.isHidden = false
                self.salarypageview.MessView.isHidden = true
                
                for q in snap.documents {
                    let ob = Earns()
                    ob.Number = Int(q.get("NumberOfResete") as! String)!
                    ob.Date = (q.get("DateOfResete") as! String)
                    ob.Total = (q.get("TotalResete") as! String)
                    ob.Currency = (q.get("Currency") as! String)
                    ob.type = (q.get("Type") as! String)
                    ob.Note = (q.get("NoteOfResete") as! String)
                    ob.target = (q.get("Target") as! String)
                    self.CashingArr.append(ob)
                    self.salarypageview.tableView.reloadData()
                }
                RappleActivityIndicatorView.stopAnimation()
            }
        }
    }
    
    // MARK:- TODO:- This Method For Add GuesterAction
    @objc func Back (_ sender:UIScreenEdgePanGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SalaryPageViewController: UITableViewDelegate {
    
}

extension SalaryPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CashingArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CashingCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CashingCell
        
        cell.NumberofResete.text = String(CashingArr[indexPath.row].Number)
        cell.DateofResete.text = CashingArr[indexPath.row].Date
       // let x = (Int(CashingArr[indexPath.row].Total))
        cell.TotalLabel.text =  CashingArr[indexPath.row].Total /*String((Int(CashingArr[indexPath.row].Total) ?? 100))*/ + "\n" + CashingArr[indexPath.row].Currency
        cell.NoteLabel.text = CashingArr[indexPath.row].Note ?? ""
        cell.TypeLabel.text = CashingArr[indexPath.row].type + " - \n" + CashingArr[indexPath.row].target
        
        return cell
    }
    
    
}

extension SalaryPageViewController: SendChange {
    
    func ReloadData(X: Bool) {
        
        if X == true {
            self.CashingArr.removeAll()
            self.LoadData()
        }
        
    }

}
