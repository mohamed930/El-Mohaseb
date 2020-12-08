//
//  SalaryPageViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 12/6/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit

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
        
        self.present(alert, animated: true) {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        }
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func LoadData() {
        /*salarypageview.tableView.isHidden = true
        salarypageview.MessView.isHidden = false*/
        
        let ob = Earns()
        ob.Number = 1
        ob.Name = "07-12-2020"
        ob.Total = "90 محلي"
        ob.type = "صرف" + " - \n" + "الصندوق"
        CashingArr.append(ob)
        salarypageview.tableView.reloadData()
        
        let ob1 = Earns()
        ob1.Number = 2
        ob1.Name = "07-12-2020"
        ob1.Total = "80 محلي"
        ob1.type = """
صرف - \
الصندوق
"""
        CashingArr.append(ob1)
        
        
        let ob2 = Earns()
        ob2.Number = 3
        ob2.Name = "08-12-2020"
        ob2.Total = "120 محلي"
        ob2.type = """
قبض - \
الصندوق
"""
        CashingArr.append(ob2)
        
        let ob3 = Earns()
        ob3.Number = 4
        ob3.Name = "08-12-2020"
        ob3.Total = "50 محلي"
        ob3.Note = "هبحك لو رنيت"
        ob3.type = """
قبض - \
الصندوق
"""
        CashingArr.append(ob3)
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
        cell.DateofResete.text = CashingArr[indexPath.row].Name
        cell.TotalLabel.text = CashingArr[indexPath.row].Total
        cell.NoteLabel.text = CashingArr[indexPath.row].Note ?? ""
        cell.TypeLabel.text = CashingArr[indexPath.row].type
        
        return cell
    }
    
    
}
