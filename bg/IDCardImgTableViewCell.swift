//
//  IDCardImgTableViewCell.swift
//  bg
//
//  Created by Apple on 2020/1/2.
//  Copyright © 2020 zhkj. All rights reserved.
//

import UIKit

class IDCardImgTableViewCell: UITableViewCell {
    @IBOutlet weak var pic_1: UIImageView!
    @IBOutlet weak var pic_2: UIImageView!
    @IBOutlet weak var pic_3: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
