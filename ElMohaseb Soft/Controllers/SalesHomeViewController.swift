//
//  SalesHomeViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 11/1/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit

class SalesHomeViewController: UIViewController {
    
    var homesalesview: HomeSalesView! {
        guard isViewLoaded else { return nil }
        return (view as! HomeSalesView)
    }
    
    var ReportsArray = Array<Reports>()
    var screenedge : UIScreenEdgePanGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        homesalesview.tableView.register(UINib(nibName: "ReseteCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        // MARK:- TODO:- This Line for adding Geusters.
        screenedge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(Back(_:)))
        screenedge.edges = .left
        view.addGestureRecognizer(screenedge)

        FetchData()
    }
    
    // MARK:- TODO:- Button Back Action.
    @IBAction func BTNBack (_ sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK:- TODO:- Button Add Action.
    @IBAction func BTNAdd (_ sender:Any) {
        Tools.openForm(MainViewName: "Main", FormID: "AddSalesView", ob: self)
    }
    
    // MARK:- TODO:- Make A Method For Fetch a Data from Database.
    func FetchData () {
        
        /*let ob = Reports()
        ob.ID = 1
        ob.Date = "2020-10-02"
        ob.Name = "Mohamed"
        ob.Price = "20"
        ReportsArray.append(ob)
        
        ob.ID = 2
        ob.Date = "2020-10-03"
        ob.Name = "Mohamed"
        ob.Price = "60"
        ReportsArray.append(ob)
        
        ob.ID = 3
        ob.Date = "2020-10-03"
        ob.Name = "Mohamed"
        ob.Price = "40"
        ReportsArray.append(ob)*/
        
        homesalesview.tableView.isHidden = true
        homesalesview.MessView.isHidden = false
    }
    
    // MARK:- TODO:- This Method For Add GuesterAction
    @objc func Back (_ sender:UIScreenEdgePanGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SalesHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
}

extension SalesHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReportsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReseteCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ReseteCell
        
        cell.NumberID.text = String(ReportsArray[indexPath.row].ID!)
        cell.DateLabel.text = ReportsArray[indexPath.row].Date!
        cell.NameID.text = ReportsArray[indexPath.row].Name!
        cell.PriceLabel.text = ReportsArray[indexPath.row].Price!
        
        return cell
    }
}
