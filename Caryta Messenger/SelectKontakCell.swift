//
//  SelectKontakCell.swift
//  Caryta Messenger
//
//  Created by Verrelio Chandra Rizky on 6/5/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class SelectKontakCell: UITableViewCell {

    @IBOutlet weak var imgProfil: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
