//
//  OrderRecordTableViewController.swift
//  bg
//
//  Created by Apple on 2019/12/31.
//  Copyright © 2019 zhkj. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderRecordTableViewController: UITableViewController {
    var dataSource=[mOrderRecord]()
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
        getOrderRecordByOrderID()
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.getOrderRecordByOrderID()
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
        cell.lb_time.text="(\(item.UserID ?? ""))\(item.CreateDate?.replacingOccurrences(of: "T", with: " ") ?? "")"
        cell.lb_content.text=item.StateName
        cell.selectionStyle = .none
        return cell
    }
    @objc func getOrderRecordByOrderID(){
        let d = [
            "OrderID":orderid
        ] as! [String:String]
        print(d)
        AlamofireHelper.post(url: GetOrderRecordByOrderID, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.dataSource=res["Data"].arrayValue.compactMap({mOrderRecord(json: $0)})
            ss.tableView.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
struct mOrderRecord {
    var StateName: String?
    var CreateDate: String?
    var Id: Int = 0
    var State: String?
    var StateHtml: String?
    var Version: Int = 0
    var RecordID: Int = 0
    var IsUse: String?
    var UserID: String?
    var OrderID: Int = 0
    
    init(json: JSON) {
        StateName = json["StateName"].stringValue
        CreateDate = json["CreateDate"].stringValue
        Id = json["Id"].intValue
        State = json["State"].stringValue
        StateHtml = json["StateHtml"].stringValue
        Version = json["Version"].intValue
        RecordID = json["RecordID"].intValue
        IsUse = json["IsUse"].stringValue
        UserID = json["UserID"].stringValue
        OrderID = json["OrderID"].intValue
    }
}
