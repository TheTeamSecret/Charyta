//
//  DetailChatCell.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/14/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class DetailChatCell: UITableViewCell {

    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var whiteWidth: NSLayoutConstraint!
    @IBOutlet weak var whiteHeight: NSLayoutConstraint!
    @IBOutlet weak var whiteLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var readReceipt: UIImageView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var blueWidth: NSLayoutConstraint!
    @IBOutlet weak var blueHeight: NSLayoutConstraint!
    @IBOutlet weak var blueLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
