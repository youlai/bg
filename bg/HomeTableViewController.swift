//
//  HomeTableViewController.swift
//  bg
//
//  Created by Apple on 2019/12/31.
//  Copyright © 2019 zhkj. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    var dataSource=[(String,String)]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="首页"
        salesToday()
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            
            strongSelf.salesToday()
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "re")
        if cell==nil{
            cell=UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "reuse")
        }
        if dataSource.count>0{
            cell?.textLabel?.text=dataSource[indexPath.row].0
            cell?.detailTextLabel?.text=dataSource[indexPath.row].1
            cell?.selectionStyle = .none
        }
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HUD.show()
        print(dataSource[indexPath.row].0)
        switch dataSource[indexPath.row].0 {
        case "今日新增会员数":
            self.navigationController?.pushViewController(SFTableViewController(orderid: "", type: "今日新增会员数"), animated: true)
       case "厂商入驻待审核":
            self.navigationController?.pushViewController(SFTableViewController(orderid: "", type: "厂商入驻待审核"), animated: true)
        case "师傅入驻待审核":
            self.navigationController?.pushViewController(SFTableViewController(orderid: "", type: "师傅入驻待审核"), animated: true)
        case "今日入驻厂商":
            self.navigationController?.pushViewController(SFTableViewController(orderid: "", type: "今日入驻厂商"), animated: true)
        case "昨日入驻厂商":
            self.navigationController?.pushViewController(SFTableViewController(orderid: "", type: "昨日入驻厂商"), animated: true)
        case "今日入驻师傅":
            self.navigationController?.pushViewController(SFTableViewController(orderid: "", type: "今日入驻师傅"), animated: true)
        case "昨日入驻师傅":
            self.navigationController?.pushViewController(SFTableViewController(orderid: "", type: "昨日入驻师傅"), animated: true)
        case "待处理提现":
            self.navigationController?.pushViewController(WithDrawTableViewController(), animated: true)
        case "已接单待服务":
            self.navigationController?.pushViewController(OrderTableViewController(status: 9), animated: true)
        case "远程费申请待审核":
            self.navigationController?.pushViewController(OrderTableViewController(status: 10), animated: true)
        case "师傅待处理仲裁":
            self.navigationController?.pushViewController(OrderTableViewController(status: 12), animated: true)
        case "厂商待处理仲裁":
            self.navigationController?.pushViewController(OrderTableViewController(status: 11), animated: true)
        case "最新工单":
            self.navigationController?.pushViewController(OrderTableViewController(status: 0), animated: true)
        case "昨日工单":
            self.navigationController?.pushViewController(OrderTableViewController(status: 1), animated: true)
        case "质保工单":
            self.navigationController?.pushViewController(OrderTableViewController(status: 2), animated: true)
        case "配件工单":
            self.navigationController?.pushViewController(OrderTableViewController(status: 8), animated: true)
        case "远程费工单":
            self.navigationController?.pushViewController(OrderTableViewController(status: 3), animated: true)
        case "留言工单":
            self.navigationController?.pushViewController(OrderTableViewController(status: 4), animated: true)
        case "区域无师傅工单":
            self.navigationController?.pushViewController(OrderTableViewController(status: 5), animated: true)
        case "完成工单":
            self.navigationController?.pushViewController(OrderTableViewController(status: 6), animated: true)
        case "已派未接单":
            self.navigationController?.pushViewController(OrderTableViewController(status: 7), animated: true)
        case "平台所有工单":
            self.navigationController?.pushViewController(OrderTableViewController(status: 13), animated: true)
        default:
            HUD.dismiss()
            break
        }
    }
    @objc func salesToday(){
        AlamofireHelper.post(url: SalesToday, parameters: nil, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.dataSource.removeAll()
            //      "orderCount" : 867,
            //      "money" : 329,
            //      "Count" : 6
            ss.dataSource.append(("平台所有工单",res["Data"]["Item2"]["orderCount"].stringValue))
            ss.dataSource.append(("今日工单总金额",res["Data"]["Item2"]["money"].stringValue))
            ss.dataSource.append(("今日新增会员数",res["Data"]["Item2"]["Count"].stringValue))
            ss.salesToday2()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    @objc func salesToday2(){
        AlamofireHelper.post(url: SalesToday2, parameters: nil, successHandler: {[weak self](res)in
            guard let ss = self else {return}
            //      "InServiceOreder" : 36,
            //      "MasterWorkerCount" : 0,
            //      "YesterdayFactoryCount" : 1,
            //      "withdrawalCount" : 67,
            //      "LongRange" : 6,
            //      "YesterdayMasterWorkerCount" : 6,
            //      "factorycomplaint" : 0,
            //      "factoryExamineCount" : 0,
            //      "TodayMasterWorkerCount" : 6,
            //      "TodayFactoryCount" : 0,
            //      "ComplaintCount" : 2
            
            ss.dataSource.append(("厂商入驻待审核",res["Data"]["Item2"]["factoryExamineCount"].stringValue))
            ss.dataSource.append(("师傅入驻待审核",res["Data"]["Item2"]["MasterWorkerCount"].stringValue))
            ss.dataSource.append(("已接单待服务",res["Data"]["Item2"]["InServiceOreder"].stringValue))
            ss.dataSource.append(("远程费申请待审核",res["Data"]["Item2"]["LongRange"].stringValue))
            ss.dataSource.append(("今日入驻厂商",res["Data"]["Item2"]["TodayFactoryCount"].stringValue))
            ss.dataSource.append(("昨日入驻厂商",res["Data"]["Item2"]["YesterdayFactoryCount"].stringValue))
            ss.dataSource.append(("今日入驻师傅",res["Data"]["Item2"]["TodayMasterWorkerCount"].stringValue))
            ss.dataSource.append(("昨日入驻师傅",res["Data"]["Item2"]["YesterdayMasterWorkerCount"].stringValue))
            ss.dataSource.append(("待处理提现",res["Data"]["Item2"]["withdrawalCount"].stringValue))
            ss.dataSource.append(("师傅待处理仲裁",res["Data"]["Item2"]["ComplaintCount"].stringValue))
            ss.dataSource.append(("厂商待处理仲裁",res["Data"]["Item2"]["factorycomplaint"].stringValue))
            ss.salesToday3()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.tableView.mj_header!.endRefreshing()
        }
    }
    @objc func salesToday3(){
        AlamofireHelper.post(url: SalesToday3, parameters: nil, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            //      "newOrder" : 13,
            //      "LeavemessageServiceCount" : 152,
            //      "completeCount" : 385,
            //      "serviceCount" : 6,
            //      "QualityAssurance" : 15,
            //      "AbolishCount" : 60,
            //      "OrderAccessroyDetailCount" : 292,
            //      "ComplaintCount2" : 2
            ss.dataSource.append(("最新工单",res["Data"]["Item2"]["newOrder"].stringValue))
            ss.dataSource.append(("昨日工单",res["Data"]["Item2"]["newOrder"].stringValue))
            ss.dataSource.append(("配件工单",res["Data"]["Item2"]["OrderAccessroyDetailCount"].stringValue))
            ss.dataSource.append(("质保工单",res["Data"]["Item2"]["QualityAssurance"].stringValue))
            ss.dataSource.append(("远程费工单",res["Data"]["Item2"]["serviceCount"].stringValue))
            ss.dataSource.append(("留言工单",res["Data"]["Item2"]["LeavemessageServiceCount"].stringValue))
            ss.dataSource.append(("区域无师傅工单",res["Data"]["Item2"]["ComplaintCount2"].stringValue))
            ss.dataSource.append(("完成工单",res["Data"]["Item2"]["completeCount"].stringValue))
            ss.dataSource.append(("已派未接单",res["Data"]["Item2"]["AbolishCount"].stringValue))
            ss.tableView.reloadData()
            ss.tableView.mj_header!.endRefreshing()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.tableView.mj_header!.endRefreshing()
        }
    }
    
}
