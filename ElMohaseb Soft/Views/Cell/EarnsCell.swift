//
//  EarnsCell.swift
//  ElMohaseb Soft
//
//  Created by Mohamed Ali on 12/9/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit

class EarnsCell: UITableViewCell {
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var NoteLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
