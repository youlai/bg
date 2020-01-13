//
//  OrderDetailsCell.swift
//  bg
//
//  Created by Apple on 2019/12/23.
//  Copyright © 2019 zhkj. All rights reserved.
//

import UIKit

class OrderDetailsCell: UITableViewCell {
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var lb4: UILabel!
    @IBOutlet weak var lb5: UILabel!
    @IBOutlet weak var lb6: UILabel!
    @IBOutlet weak var lb7: UILabel!
    @IBOutlet weak var lb8: UILabel!
    @IBOutlet weak var lb9: UILabel!
    @IBOutlet weak var lb10: UILabel!
    @IBOutlet weak var lb11: UILabel!
    @IBOutlet weak var lb12: UILabel!
    @IBOutlet weak var lb13: UILabel!
    @IBOutlet weak var lb14: UILabel!
    @IBOutlet weak var lb15: UILabel!
    @IBOutlet weak var lb16: UILabel!
    @IBOutlet weak var lb17: UILabel!
    @IBOutlet weak var lb18: UILabel!
    @IBOutlet weak var lb19: UILabel!
    @IBOutlet weak var lb20: UILabel!
    @IBOutlet weak var lb21: UILabel!
    @IBOutlet weak var lb22: UILabel!
    @IBOutlet weak var lb23: UILabel!
    @IBOutlet weak var lb24: UILabel!
    @IBOutlet weak var lb25: UILabel!
    @IBOutlet weak var lb26: UILabel!
    @IBOutlet weak var lb27: UILabel!
    @IBOutlet weak var lb28: UILabel!
    @IBOutlet weak var btn_modify: UIButton!
    @IBOutlet weak var btn_close: UIButton!
    @IBOutlet weak var btn_abolish: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK:
    func filldata(order:mData!){
        if order != nil {
            lb1.text="\(order.UserName!)   \(order.Phone!)"
            lb2.text="\(order.Address!)"
            lb3.text="服务类型：\(order.TypeName!)/\(order.GuaranteeStr!)"
            lb4.text="品牌：\(order.BrandName!)"
            lb5.text="型号：\(order.ProductType!)"
            lb6.text="工单描述：\(order.Memo!)"
            lb7.text="接单人：\(order.SendUser!)"
            lb8.text="派单人：\(order.LoginUser!)"
            lb9.text="录单人：\(order.UserID!)"
            lb10.text="是否加急：\(order.Extra!)"
            lb11.text="加急时间：\(order.ExtraTime!)"
            lb12.text="加急费用：\(order.ExtraFee)"
            lb13.text="远程费：\(order.BeyondMoney)"
            lb14.text="超出公里：\(order.BeyondDistance!)"
            lb15.text="审核状态：\(order.BeyondStateStr!)"
            lb16.text="配件金额：\(order.AccessoryMoney)"
            lb17.text="配件状态：\(order.AccessoryApplyState!)"
            lb18.text="审核状态：\(order.AccessoryApplyState!)"
            lb19.text="物流单号：\(order.ExpressNo!)"
            lb20.text="返件信息：\(order.ReturnAccessoryMsg!)"
            lb21.text="客户是否收到货：\(order.IsRecevieGoods!)"
            lb22.text="物流单号：\(order.ExpressNo!)"
            lb23.text="平台金额：\(order.terraceMoney)"
            lb24.text="工单金额：\(order.OrderMoney)"
            lb25.text="创建时间：\(order.CreateDate!)"
            lb26.text="接单时间：\(order.ReceiveOrderDate!)"
            lb27.text="结束时间：\(order.RepairCompleteDate!)"
            lb28.text="评价时间："
            
        }
    }
}
