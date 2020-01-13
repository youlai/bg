//
//  OrderRecordTableViewController.swift
//  bg
//
//  Created by Apple on 2019/12/31.
//  Copyright © 2019 zhkj. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderPayRecordTableViewController: UITableViewController {
    var dataSource=[mOrderPayRecord]()
    var orderid:String!
    init(orderid:String!){
        super.init(nibName: nil, bundle: nil)
        self.orderid=orderid
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "XgyOrderRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "re")
        tableView.separatorStyle = .none
        getOrderPayByOrderID()
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.getOrderPayByOrderID()
            strongSelf.tableView.mj_header?.endRefreshing()
        })
        tableView.mj_header = header;
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "re") as! XgyOrderRecordTableViewCell
        let item=dataSource[indexPath.row]
        cell.lb_time.text="\(item.CreateTime?.replacingOccurrences(of: "T", with: " ") ?? "")"
        cell.lb_content.text="\(item.PayName ?? "")支付￥\(item.PayMoney)"
        cell.selectionStyle = .none
        return cell
    }
    @objc func getOrderPayByOrderID(){
        let d = [
            "OrderID":orderid
        ] as! [String:String]
        print(d)
        AlamofireHelper.post(url: GetOrderPayByOrderID, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.dataSource=res["Data"].arrayValue.compactMap({mOrderPayRecord(json: $0)})
            ss.tableView.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
struct mOrderPayRecord {
    var page: Int = 0
    var ApplyNum: Int = 0
    var PayMoney: Int = 0
    var PayID: Int = 0
    var CreateTimeEnd: String?
    var TypeID: String?
    var Version: Int = 0
    var OrderAccessoryId: Int = 0
    var IsUse: String?
    var CreateTime: String?
    var Relation: String?
    var OrderID: Int = 0
    var State: String?
    var UserID: String?
    var Id: Int = 0
    var CreateTimeStart: String?
    var QApplyNum: Int = 0
    var limit: Int = 0
    var PayTypeCode: String?
    var PayName: String?
    var ItemID: Int = 0
    var AccessoryState: String?

    init(json: JSON) {
        page = json["page"].intValue
        ApplyNum = json["ApplyNum"].intValue
        PayMoney = json["PayMoney"].intValue
        PayID = json["PayID"].intValue
        CreateTimeEnd = json["CreateTimeEnd"].stringValue
        TypeID = json["TypeID"].stringValue
        Version = json["Version"].intValue
        OrderAccessoryId = json["OrderAccessoryId"].intValue
        IsUse = json["IsUse"].stringValue
        CreateTime = json["CreateTime"].stringValue
        Relation = json["Relation"].stringValue
        OrderID = json["OrderID"].intValue
        State = json["State"].stringValue
        UserID = json["UserID"].stringValue
        Id = json["Id"].intValue
        CreateTimeStart = json["CreateTimeStart"].stringValue
        QApplyNum = json["QApplyNum"].intValue
        limit = json["limit"].intValue
        PayTypeCode = json["PayTypeCode"].stringValue
        PayName = json["PayName"].stringValue
        ItemID = json["ItemID"].intValue
        AccessoryState = json["AccessoryState"].stringValue
    }
}
