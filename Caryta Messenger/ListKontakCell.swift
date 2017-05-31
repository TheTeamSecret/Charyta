//
//  ListKontakCell.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/18/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class ListKontakCell: UITableViewCell {
    
    @IBOutlet weak var kontakView: UIView!
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
