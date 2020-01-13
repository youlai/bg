//
//  OrderServiceRecordTableViewController.swift
//  bg
//
//  Created by Apple on 2019/12/31.
//  Copyright © 2019 zhkj. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderServiceRecordTableViewController: UITableViewController {
    var dataSource=[mOrderServiceDetail]()
    var orderid:String!
    var detail:mOrderDetail!
    init(orderid:String!){
        super.init(nibName: nil, bundle: nil)
        self.orderid=orderid
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getOrderInfo()
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.getOrderInfo()
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
        var cell=tableView.dequeueReusableCell(withIdentifier: "re")
        if cell==nil{
            cell=UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "reuse")
        }
        let item=dataSource[indexPath.row]
        cell!.textLabel!.text=item.ServiceName
        cell!.selectionStyle = .none
        return cell!
    }
    //MARK:获取工单详情
    @objc func getOrderInfo(){
        let d = ["OrderID":orderid!]
        AlamofireHelper.post(url: GetOrderInfo, parameters: d , successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.detail=mOrderDetail.init(json: res)
            ss.dataSource=ss.detail.Data!.OrderServiceDetail
            ss.tableView.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
