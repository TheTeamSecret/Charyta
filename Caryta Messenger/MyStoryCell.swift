//
//  MyStoryCell.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 9/18/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class MyStoryCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var seenLbl: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
