//
//  SFTableViewController.swift
//  bg
//
//  Created by Apple on 2019/12/26.
//  Copyright © 2019 zhkj. All rights reserved.
//

import UIKit
import SwiftyJSON

class SFTableViewController: UITableViewController,EmptyViewProtocol,UISearchBarDelegate {
    var showEmtpy: Bool{
        get {
            return dataSouce.count == 0
        }
    }
    func configEmptyView() -> UIView? {
        let view=Bundle.main.loadNibNamed("emptyView", owner: nil, options: nil)?[0]as?UIView
        view?.height=tableView.frame.height
        view?.width=screenW
        
        return view
    }
    var searchBar: UISearchBar!
    var orderid:String!
    var page=1
    var type:String!
    var keyword:String!
    var limit:Int=30
    var dataSouce=[mSF]()
    var tempList=[mSF]()
    init(orderid:String!,type:String){
        super.init(nibName: nil, bundle: nil)
        self.orderid=orderid
        self.type=type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setEmtpyViewDelegate(target: self)
        tableView.backgroundColor = "#F0F0F0".color()
        tableView.separatorStyle = .singleLine
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.page = 1
            strongSelf.tableView.mj_footer!.state = .idle
            strongSelf.tableView.mj_header!.endRefreshing()
            switch strongSelf.type {
            case "今日新增会员数":
                strongSelf.getUserInfoList()
            case "厂商入驻待审核":
                strongSelf.getUserInfoList()
            case "师傅入驻待审核":
                strongSelf.getUserInfoList()
            case "今日入驻厂商":
                strongSelf.getUserInfoList()
            case "昨日入驻厂商":
                strongSelf.getUserInfoList()
            case "今日入驻师傅":
                strongSelf.getUserInfoList()
            case "昨日入驻师傅":
                strongSelf.getUserInfoList()
            case "指派":
                strongSelf.getMUserList()
            case "转派":
                strongSelf.getMUserList()
            default:
                break
            }
        })
        
        tableView.mj_header = header;
        
        let footer = TTRefreshFooter  {  [weak self] in
            guard let strongSelf = self else{return}
            strongSelf.page = strongSelf.page + 1
            switch strongSelf.type {
            case "今日新增会员数":
                strongSelf.getUserInfoList()
            case "厂商入驻待审核":
                strongSelf.getUserInfoList()
            case "师傅入驻待审核":
                strongSelf.getUserInfoList()
            case "今日入驻厂商":
                strongSelf.getUserInfoList()
            case "昨日入驻厂商":
                strongSelf.getUserInfoList()
            case "今日入驻师傅":
                strongSelf.getUserInfoList()
            case "昨日入驻师傅":
                strongSelf.getUserInfoList()
            case "指派":
                strongSelf.getMUserList()
            case "转派":
                strongSelf.getMUserList()
            default:
                break
            }
        }
        
        tableView.mj_footer = footer
        tableView.mj_footer!.isHidden = false
        switch type {
        case "今日新增会员数":
            getUserInfoList()
        case "厂商入驻待审核":
            getUserInfoList()
        case "师傅入驻待审核":
            getUserInfoList()
        case "今日入驻厂商":
            getUserInfoList()
        case "昨日入驻厂商":
            getUserInfoList()
        case "今日入驻师傅":
            getUserInfoList()
        case "昨日入驻师傅":
            getUserInfoList()
        case "指派":
            getMUserList()
        case "转派":
            getMUserList()
        default:
            break
        }
        
        initSearchBar()
    }
    func initSearchBar() {
        searchBar = UISearchBar()
        searchBar.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        searchBar.delegate = self
        searchBar.placeholder = "请输入手机号码"
        searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar
    }
    //MARK:- UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        page=1
        keyword=searchBar.text
        switch type {
        case "今日新增会员数":
            getUserInfoList()
        case "厂商入驻待审核":
            getUserInfoList()
        case "师傅入驻待审核":
            getUserInfoList()
        case "今日入驻厂商":
            getUserInfoList()
        case "昨日入驻厂商":
            getUserInfoList()
        case "今日入驻师傅":
            getUserInfoList()
        case "昨日入驻师傅":
            getUserInfoList()
        case "指派":
            getMUserList()
        case "转派":
            getMUserList()
        default:
            break
        }
    }
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSouce.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "re")
        if cell == nil{
            cell=OrderTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "re")
        }
        let item=dataSouce[indexPath.row]
        cell?.textLabel?.text="\(item.UserID! )      \(item.TrueName!)     \r\n\(item.Address!) （\(item.IfAuthStr ?? "")）"
        cell?.textLabel!.numberOfLines=0
        cell!.selectionStyle = .none
        
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item=dataSouce[indexPath.row]
        switch type {
        case "今日新增会员数":
            self.navigationController?.pushViewController(PersonalInfoTableViewController(userid: item.UserID!), animated: true)
        case "厂商入驻待审核":
            self.navigationController?.pushViewController(PersonalInfoTableViewController(userid: item.UserID!), animated: true)
        case "师傅入驻待审核":
            self.navigationController?.pushViewController(PersonalInfoTableViewController(userid: item.UserID!), animated: true)
        case "今日入驻厂商":
            self.navigationController?.pushViewController(PersonalInfoTableViewController(userid: item.UserID!), animated: true)
        case "昨日入驻厂商":
            self.navigationController?.pushViewController(PersonalInfoTableViewController(userid: item.UserID!), animated: true)
        case "今日入驻师傅":
            self.navigationController?.pushViewController(PersonalInfoTableViewController(userid: item.UserID!), animated: true)
        case "昨日入驻师傅":
            self.navigationController?.pushViewController(PersonalInfoTableViewController(userid: item.UserID!), animated: true)
        default:
            zp(user: item)
            break
        }
    }
    //MARK:指派转派二次确认
    func zp(user:mSF!){
        let alertVC : UIAlertController = UIAlertController.init(title: "是否\(type ?? "")给\(user.UserID! )", message: "", preferredStyle: .alert)
        let falseAA : UIAlertAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let trueAA : UIAlertAction = UIAlertAction.init(title: "确定", style: .default) { (alertAction) in
            if self.type=="指派"{
                self.sendOrder(orderid: self.orderid, userid: user.UserID!, loginUser: UserID!, typeid: "1")
            }else{
                self.sendOrder(orderid: self.orderid, userid: user.UserID!, loginUser: UserID!, typeid: "2")
            }
            
        }
        alertVC.addAction(falseAA)
        alertVC.addAction(trueAA)
        self.present(alertVC, animated: true, completion: nil)
    }
    //MARK:指派转派 TypeId:操作：1指定派单2改派工单
    @objc func sendOrder(orderid:String!,userid:String!,loginUser:String!,typeid:String!){
        let d = ["UserID":userid,
                 "OrderID":orderid,
                 "LoginUser":loginUser,
                 "TypeID":typeid
            ] as! [String : String]
        print(d)
        AlamofireHelper.post(url: SendOrder, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                HUD.showText("\(ss.type ?? "")成功")
                ss.navigationController?.popViewController(animated: true)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    // MARK: - 获取师傅列表
    @objc func getMUserList(){
        var d = ["limit":"\(limit)",
            "page":"\(page)",
            "Type":"7"
        ]
        if keyword != nil{
            d["UserID"]=keyword
        }
        print(d)
        AlamofireHelper.post(url: GetMUserList, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            
            if ss.page == 1{ ss.dataSouce.removeAll()}
            
            if ss.tableView.mj_footer!.isRefreshing {
                ss.tableView.mj_footer!.endRefreshing()
                
            }
            if res["StatusCode"].intValue==200{
                ss.tempList=res["Data"]["data"].arrayValue.compactMap({ mSF(json: $0)})
                if ss.tempList.count>0 {
                    if ss.tableView.mj_footer!.isHidden && ss.tempList.count > 0 {
                        ss.tableView.mj_footer!.isHidden = false
                    }
                    ss.dataSouce.insert(contentsOf: ss.tempList, at: ss.dataSouce.count)
                    if ss.tempList.count < ss.limit {
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
    // MARK: - 获取账号列表
    @objc func getUserInfoList(){
        var d = ["limit":"\(limit)",
            "page":"\(page)"
        ]
        if keyword != nil{
            d["UserID"]=keyword
        }
        switch type {
        case "今日新增会员数":
            d["StartDate"]=nowTime()
            d["EndDate"]=nowTime()
        case "厂商入驻待审核":
            d["Type"]="6"
            d["IfAuth"]="0"
        case "师傅入驻待审核":
            d["Type"]="7"
            d["IfAuth"]="0"
        case "今日入驻厂商":
            d["Type"]="6"
            d["StartDate"]=nowTime()
            d["EndDate"]=nowTime()
        case "昨日入驻厂商":
            d["Type"]="6"
            d["StartDate"]=getLastDay(nowTime())
            d["EndDate"]=getLastDay(nowTime())
        case "今日入驻师傅":
            d["Type"]="7"
            d["StartDate"]=nowTime()
            d["EndDate"]=nowTime()
        case "昨日入驻师傅":
            d["Type"]="7"
            d["StartDate"]=getLastDay(nowTime())
            d["EndDate"]=getLastDay(nowTime())
        default:
            break
        }
        print(d)
        AlamofireHelper.post(url: GetUserInfoList, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            
            if ss.page == 1{ ss.dataSouce.removeAll()}
            
            if ss.tableView.mj_footer!.isRefreshing {
                ss.tableView.mj_footer!.endRefreshing()
                
            }
            if res["StatusCode"].intValue==200{
                ss.tempList=res["Data"]["data"].arrayValue.compactMap({ mSF(json: $0)})
                if ss.tempList.count>0 {
                    if ss.tableView.mj_footer!.isHidden && ss.tempList.count > 0 {
                        ss.tableView.mj_footer!.isHidden = false
                    }
                    ss.dataSouce.insert(contentsOf: ss.tempList, at: ss.dataSouce.count)
                    if ss.tempList.count < ss.limit {
                        ss.tableView.mj_footer!.state = .noMoreData
                    }
                }else {
                    ss.tableView.mj_footer!.state = .noMoreData
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
    // MARK: 获取当前时间
    func nowTime() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let time = formatter.string(from: currentDate)
        return time
    }
    // MARK: 前一天的时间
    // nowDay 是传入的需要计算的日期
    func getLastDay(_ nowDay: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 先把传入的时间转为 date
        let date = dateFormatter.date(from: nowDay)
        let lastTime: TimeInterval = -(24*60*60) // 往前减去一天的秒数，昨天
        //        let nextTime: TimeInterval = 24*60*60 // 这是后一天的时间，明天
        
        let lastDate = date?.addingTimeInterval(lastTime)
        let lastDay = dateFormatter.string(from: lastDate!)
        return lastDay
    }
}
struct mSF {
    var AreaCode: String?
    var IsUse: String?
    var AuthMessage: String?
    var Address: String?
    var Distance: Int = 0
    var NickName: String?
    var ServiceTotalMoney: Int = 0
    var CreateDate: String?
    var Id: Int = 0
    var DistrictCode: String?
    var TopRank: String?
    var Longitude: String?
    var ServiceComplaintNum: Int = 0
    var WaitMoney: Int = 0
    var ProvinceCode: String?
    var `Type`: String?
    var TypeStr: String?{
        get{
            if self.Type=="5"{
                return "平台账号"
            }else if self.Type=="6"{
                return "工厂端账号"
            }else if self.Type=="7"{
                return "师傅端账号"
            }else{
                return "未知"
            }
        }
    }
    var ServiceStart: String?
    var Skills: String?
    var UserID: String?
    var ConDeposit: Int = 0
    var Con: Int = 0
    var RemainMoney: Int = 0
    var Version: Int = 0
    var Sex: String?
    var limit: Int = 0
    var Dimension: String?
    var IsNew: String?
    var CityCode: String?
    var ServiceTotalOrderNum: Int = 0
    var TotalMoney: Int = 0
    var DepositMoney: Int = 0
    var RoleID: String?
    var page: Int = 0
    var TrueName: String?
    var IfAuth: String?
    var IfAuthStr: String?{
        get{
            if self.IfAuth=="0"{
                return "已实名待审核"
            }else if self.IfAuth=="-1"{
                return "实名未通过"
            }else if self.IfAuth=="1"{
                return "已实名"
            }else{
                return "未实名"
            }
        }
    }
    var Avator: String?
    var PayPassWord: String?
    var LastLoginDate: String?
    var IDCard: String?
    var DepositFrozenMoney: Int = 0
    var FrozenMoney: Int = 0
    var AccountID: Int = 0
    var PassWord: String?
    var LoginCount: Int = 0
    var ParentUserID: String?
    var Phone: String?
    
    init(json: JSON) {
        AreaCode = json["AreaCode"].stringValue
        IsUse = json["IsUse"].stringValue
        AuthMessage = json["AuthMessage"].stringValue
        Address = json["Address"].stringValue
        Distance = json["Distance"].intValue
        NickName = json["NickName"].stringValue
        ServiceTotalMoney = json["ServiceTotalMoney"].intValue
        CreateDate = json["CreateDate"].stringValue
        Id = json["Id"].intValue
        DistrictCode = json["DistrictCode"].stringValue
        TopRank = json["TopRank"].stringValue
        Longitude = json["Longitude"].stringValue
        ServiceComplaintNum = json["ServiceComplaintNum"].intValue
        WaitMoney = json["WaitMoney"].intValue
        ProvinceCode = json["ProvinceCode"].stringValue
        Type = json["Type"].stringValue
        ServiceStart = json["ServiceStart"].stringValue
        Skills = json["Skills"].stringValue
        UserID = json["UserID"].stringValue
        ConDeposit = json["ConDeposit"].intValue
        Con = json["Con"].intValue
        RemainMoney = json["RemainMoney"].intValue
        Version = json["Version"].intValue
        Sex = json["Sex"].stringValue
        limit = json["limit"].intValue
        Dimension = json["Dimension"].stringValue
        IsNew = json["IsNew"].stringValue
        CityCode = json["CityCode"].stringValue
        ServiceTotalOrderNum = json["ServiceTotalOrderNum"].intValue
        TotalMoney = json["TotalMoney"].intValue
        DepositMoney = json["DepositMoney"].intValue
        RoleID = json["RoleID"].stringValue
        page = json["page"].intValue
        TrueName = json["TrueName"].stringValue
        IfAuth = json["IfAuth"].stringValue
        Avator = json["Avator"].stringValue
        PayPassWord = json["PayPassWord"].stringValue
        LastLoginDate = json["LastLoginDate"].stringValue
        IDCard = json["IDCard"].stringValue
        DepositFrozenMoney = json["DepositFrozenMoney"].intValue
        FrozenMoney = json["FrozenMoney"].intValue
        AccountID = json["AccountID"].intValue
        PassWord = json["PassWord"].stringValue
        LoginCount = json["LoginCount"].intValue
        ParentUserID = json["ParentUserID"].stringValue
        Phone = json["Phone"].stringValue
    }
}
