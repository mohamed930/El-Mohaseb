//
//  SalesHomeViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 11/1/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
import RappleProgressHUD

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
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let next = storyBoard.instantiateViewController(withIdentifier: "AddSalesView") as! AddSaleViewController
        next.delegate = self
        next.Flag = false
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
    }
    
    // MARK:- TODO:- Make A Method For Fetch a Data from Database.
    func FetchData () {
        /*homesalesview.tableView.isHidden = true
        homesalesview.MessView.isHidden = false*/
        
        Firebase.publicreadWithWhereCondtion(collectionName: "resete", key: "EmailID", value: (Auth.auth().currentUser?.email)!) { (snap) in
            if snap.count == 0 {
                RappleActivityIndicatorView.stopAnimation()
                self.homesalesview.tableView.isHidden = true
                self.homesalesview.MessView.isHidden = false
            }
            else {
                
                self.homesalesview.tableView.isHidden = false
                self.homesalesview.MessView.isHidden = true
                self.homesalesview.CountLabel.text = String(snap.count)

                for q in snap.documents {
                    let  ob = Reports()
                    ob.ID = Int(q.get("ReseteNumber") as! String)
                    ob.Name = (q.get("CustomerName") as! String)
                    ob.Date = (q.get("Date") as! String)
                    ob.Price = (q.get("TotalPrices") as! String)
                    ob.ReportID = (q.get("ProductsID") as! String)
                    self.ReportsArray.append(ob)
                    self.homesalesview.tableView.reloadData()
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

extension SalesHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let next = story.instantiateViewController(withIdentifier: "AddSalesView") as! AddSaleViewController
        next.modalPresentationStyle = .fullScreen
        next.ProductID = String(self.ReportsArray[indexPath.row].ReportID!)
        next.Flag = true
        next.delegate = self
        self.present(next, animated: true, completion: nil)
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

extension SalesHomeViewController: ReloadData {
    func Reload(X: Int) {
        
        if X == 1 {
            self.ReportsArray.removeAll()
            FetchData()
        }
        
    }
    
    
}
