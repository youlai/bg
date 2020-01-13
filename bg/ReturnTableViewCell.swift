//
//  ReturnTableViewCell.swift
//  bg
//
//  Created by Apple on 2020/1/8.
//  Copyright © 2020 zhkj. All rights reserved.
//

import UIKit

class ReturnTableViewCell: UITableViewCell {

    @IBOutlet weak var iv_photo1: UIImageView!
    @IBOutlet weak var iv_photo2: UIImageView!
    @IBOutlet weak var iv_photo3: UIImageView!
    @IBOutlet weak var iv_photo4: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
