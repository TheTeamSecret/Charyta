//
//  PopUpListDialCell.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 8/29/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class PopUpListDialCell: UITableViewCell {

    @IBOutlet weak var lblNama: UILabel!
    @IBOutlet weak var lblDial: UILabel!
    @IBOutlet weak var btnList: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
