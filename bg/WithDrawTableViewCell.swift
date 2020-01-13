//
//  WithDrawTableViewCell.swift
//  bg
//
//  Created by Apple on 2020/1/2.
//  Copyright © 2020 zhkj. All rights reserved.
//

import UIKit

class WithDrawTableViewCell: UITableViewCell {
    @IBOutlet weak var lb_payname: UILabel!
    @IBOutlet weak var lb_payno: UILabel!
    @IBOutlet weak var lb_paymoney: UILabel!
    @IBOutlet weak var lb_userid: UILabel!
    @IBOutlet weak var lb_payinfo: UILabel!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var btn_copy: UIButton!
    @IBOutlet weak var btn_ok: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buttonStyle(btn: btn_copy)
        buttonStyle(btn: btn_ok)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK:按钮样式
    func buttonStyle(btn:UIButton){
        btn.border(color: UIColor.lightGray, width: 1, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 5)
        btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn.contentEdgeInsets=UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        btn.snp.makeConstraints{(mask) in
            mask.height.equalTo(50)
        }
    }

}
