//
//  ChatCell.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/17/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var userAva: UIImageView!
    @IBOutlet weak var otherAva: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var valueView: UIView!
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var valueViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
