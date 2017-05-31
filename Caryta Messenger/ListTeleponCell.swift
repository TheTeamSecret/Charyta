//
//  ListTeleponCell.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/16/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class ListTeleponCell: UITableViewCell {

    @IBOutlet weak var typeImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var infoBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
