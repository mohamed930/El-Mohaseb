//
//  ProductsCell.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 11/1/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit

class ProductsCell: UITableViewCell {
    
    @IBOutlet weak var ProductNameLabel: UILabel!
    @IBOutlet weak var AmmountLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var FinalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }    
}
