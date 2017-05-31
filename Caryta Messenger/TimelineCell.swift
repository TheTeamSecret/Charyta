//
//  TimelineCell.swift
//  Caryta Messenger
//
//  Created by www.caryta.com on 5/22/17.
//  Copyright © 2017 Caryta. All rights reserved.
//

import UIKit

class TimelineCell: UITableViewCell {
    
    @IBOutlet weak var profilImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeUnlike(_ sender: UIButton) {
        
        if likeBtn.titleLabel!.text == "Suka" {
        
            likeBtn.setTitle("Disukai", for: .normal)
        
        }else if likeBtn.titleLabel!.text == "Disukai" {
            
            likeBtn.setTitle("Suka", for: .normal)
            
        }
        
    }

}
