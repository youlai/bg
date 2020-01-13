//
//  WithDrawTableViewController.swift
//  bg
//
//  Created by Apple on 2019/12/31.
//  Copyright © 2019 zhkj. All rights reserved.
//

import UIKit
import SwiftyJSON
import SKPhotoBrowser

class WithDrawTableViewController: UITableViewController {
    var dataSource=[mWithDraw]()
    var pageNo=1
    var limit=10
    var templist=[mWithDraw]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="待处理提现"
        tableView.register(UINib(nibName: "WithDrawTableViewCell", bundle: nil), forCellReuseIdentifier: "withdraw")
        
        getWithDrawList()
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNo=1
            strongSelf.tableView.mj_footer!.state = .idle
            strongSelf.tableView.mj_header!.endRefreshing()
            strongSelf.getWithDrawList()
        })
        
        tableView.mj_header = header;
        let footer = TTRefreshFooter  {  [weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNo = strongSelf.pageNo + 1
            strongSelf.getWithDrawList()
        }
        
        tableView.mj_footer = footer
        tableView.mj_footer!.isHidden = false
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
    
    //    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 50
    //    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "withdraw")as! WithDrawTableViewCell
        let item=dataSource[indexPath.row]
        cell.lb_payname?.text="姓名：\(item.PayName!)"
        cell.lb_payno?.text="银行卡号：\(item.PayNo!)"
        cell.lb_payinfo?.text="开户银行：\(item.PayInfo!)"
        cell.lb_paymoney?.text="提现金额：￥\(item.PayMoney)"
        cell.lb_time?.text="提现时间：\(item.CreateTime!)"
        cell.lb_userid?.text="提现账号：\(item.UserID!)"
        cell.btn_copy.addTarget(self, action: #selector(copyNo(sender:)), for: UIControl.Event.touchUpInside)
        cell.btn_ok.addTarget(self, action: #selector(withdraw(sender:)), for: UIControl.Event.touchUpInside)
        cell.btn_copy.tag=indexPath.row
        cell.btn_ok.tag=indexPath.row
        cell.selectionStyle = .none
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item=dataSource[indexPath.row]
        self.navigationController?.pushViewController(WithDrawOrderTableViewController(user: item.UserID!,name: item.PayName!), animated: true)
    }
    //MARK:复制卡号
    @objc func copyNo(sender:UIButton!){
        let item=dataSource[sender.tag]
        let pas = UIPasteboard.general
        pas.string = item.PayNo
        HUD.showText("已复制到剪切板")
    }
    //MARK:提现成功
    @objc func withdraw(sender:UIButton!){
        let item=dataSource[sender.tag]
        let alertVC : UIAlertController = UIAlertController.init(title: "是否提现成功？", message: "", preferredStyle: .alert)
        let falseAA : UIAlertAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let trueAA : UIAlertAction = UIAlertAction.init(title: "确定", style: .default) { (alertAction) in
            let d = ["WithDrawID":"\(item.WithDrawID)",
                "ApproveUser":UserID!
            ]
//            ["ApproveUser": "admin", "WithDrawID": "393"]
//            {
//              "Data" : {
//                "Item1" : true,
//                "Item2" : "审核成功"
//              },
//              "StatusCode" : 200,
//              "Info" : "请求(或处理)成功"
//            }
            print(d)
            AlamofireHelper.post(url: ConfirmWithDraw, parameters: d, successHandler: {[weak self](res)in
                HUD.dismiss()
                guard let ss = self else {return}
                if res["Data"]["Item1"].boolValue{
                    HUD.showText("操作成功")
                    ss.getWithDrawList()
                }
            }){[weak self] (error) in
                HUD.dismiss()
                guard let ss = self else {return}
            }
        }
        alertVC.addAction(falseAA)
        alertVC.addAction(trueAA)
        self.present(alertVC, animated: true, completion: nil)
    }
    // MARK: - 获取提现列表
    @objc func getWithDrawList(){
        let d = ["limit":"\(limit)",
            "page":"\(pageNo)",
            "State":"0"
        ]
        print(d)
        AlamofireHelper.post(url: GetWithDrawList, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if ss.pageNo == 1{ ss.dataSource.removeAll()}
            
            if ss.tableView.mj_footer!.isRefreshing {
                ss.tableView.mj_footer!.endRefreshing()
                
            }
            if res["StatusCode"].intValue==200{
                ss.templist=res["Data"]["data"].arrayValue.compactMap({ mWithDraw(json: $0)})
                if ss.templist.count>0 {
                    if ss.tableView.mj_footer!.isHidden && ss.templist.count > 0 {
                        ss.tableView.mj_footer!.isHidden = false
                    }
                    ss.dataSource.insert(contentsOf: ss.templist, at: ss.dataSource.count)
                    if ss.templist.count < ss.limit {
                        ss.tableView.mj_footer!.endRefreshingWithNoMoreData()
                    }
                }else {
                    ss.tableView.mj_footer!.endRefreshingWithNoMoreData()
                }
                ss.tableView.reloadData()
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
            if ss.tableView.mj_header!.isRefreshing{ss.tableView.mj_header!.endRefreshing()}
            else if ss.tableView.mj_footer!.isRefreshing {ss.tableView.mj_footer!.endRefreshing()}
        }
    }
}
struct mWithDraw {
    var Id: Int = 0
    var Version: Int = 0
    var DrawType: String?
    var limit: Int = 0
    var PayMoney: Float = 0.0
    var CreateTime: String?
    var WithDrawID: Int = 0
    var page: Int = 0
    var UserID: String?
    var ApproveUser: String?
    var State: String?
    var PayNo: String?
    var IsUse: String?
    var PayName: String?
    var ApproveTime: String?
    var PayInfo: String?
    
    init(json: JSON) {
        Id = json["Id"].intValue
        Version = json["Version"].intValue
        DrawType = json["DrawType"].stringValue
        limit = json["limit"].intValue
        PayMoney = json["PayMoney"].floatValue
        CreateTime = json["CreateTime"].stringValue
        WithDrawID = json["WithDrawID"].intValue
        page = json["page"].intValue
        UserID = json["UserID"].stringValue
        ApproveUser = json["ApproveUser"].stringValue
        State = json["State"].stringValue
        PayNo = json["PayNo"].stringValue
        IsUse = json["IsUse"].stringValue
        PayName = json["PayName"].stringValue
        ApproveTime = json["ApproveTime"].stringValue
        PayInfo = json["PayInfo"].stringValue
    }
}
