//
//  DialCodeCell.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 5/24/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class DialCodeCell: UITableViewCell {

    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryDial: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
