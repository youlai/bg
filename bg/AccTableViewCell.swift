//
//  AccTableViewCell.swift
//  bg
//
//  Created by Apple on 2020/1/7.
//  Copyright © 2020 zhkj. All rights reserved.
//

import UIKit

class AccTableViewCell: UITableViewCell {

    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var iv_photo1: UIImageView!
    @IBOutlet weak var iv_photo2: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
