//
//  BuyingViewController.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 11/28/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import ProgressHUD
import FirebaseAuth
import RappleProgressHUD

class BuyingViewController: UIViewController {
    
    var screenedge : UIScreenEdgePanGestureRecognizer!
    var ReportsArray = Array<Reports>()
    
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
        
        buyingview.tableView.register(UINib(nibName: "ReseteCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        FetchData()
        
    }
    
    @IBAction func BTNBack(_ sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BTNAddBuying (_ sender:Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let next = story.instantiateViewController(withIdentifier: "AddBuyingView") as! AddBuyingViewController
        next.delegate = self
        next.Flag = false
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
    }
    
    // MARK:- TODO:- Make A Method For Fetch a Data from Database.
    func FetchData () {
        /*homesalesview.tableView.isHidden = true
        homesalesview.MessView.isHidden = false*/
        
        Firebase.publicreadWithWhereCondtion(collectionName: "Byuedresete", key: "EmailID", value: (Auth.auth().currentUser?.email)!) { (snap) in
            if snap.count == 0 {
                RappleActivityIndicatorView.stopAnimation()
                self.buyingview.tableView.isHidden = true
                self.buyingview.MessView.isHidden = false
            }
            else {
                
                self.buyingview.tableView.isHidden = false
                self.buyingview.MessView.isHidden = true

                for q in snap.documents {
                    let  ob = Reports()
                    ob.ID = Int(q.get("ReseteNumber") as! String)
                    ob.Name = (q.get("CustomerName") as! String)
                    ob.Date = (q.get("Date") as! String)
                    ob.Price = (q.get("TotalPrices") as! String)
                    ob.ReportID = (q.get("ProductsID") as! String)
                    self.buyingview.countLabel.text = String(Int(self.buyingview.countLabel.text!)! + Int(q.get("TotalPrices") as! String)!)
                    self.ReportsArray.append(ob)
                    self.buyingview.tableView.reloadData()
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

extension BuyingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let next = story.instantiateViewController(withIdentifier: "AddBuyingView") as! AddBuyingViewController
        next.modalPresentationStyle = .fullScreen
        next.ProductID = String(self.ReportsArray[indexPath.row].ReportID!)
        next.Flag = true
        next.delegate = self
        self.present(next, animated: true, completion: nil)
    }
}

extension BuyingViewController: UITableViewDataSource {
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


extension BuyingViewController: ReloadDataBuying {
    func Reload(X: Int) {
        if X == 1 {
            self.ReportsArray.removeAll()
            FetchData()
        }
    }
    
    
}
