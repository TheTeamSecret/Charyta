//
//  ListPhoneCell.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/13/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class TestListPhoneCell: UITableViewCell {

    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var initialLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var msgBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var typeImg: UIImageView!
    @IBOutlet weak var selectBtnWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
