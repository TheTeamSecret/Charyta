//
//  ListChatCell.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/16/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class ListChatCell: UITableViewCell {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var lastLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var badge: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
