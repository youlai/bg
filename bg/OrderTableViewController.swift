//
//  OrderTableViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/26.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import EventKit
import MapKit

class OrderTableViewController: UITableViewController,EmptyViewProtocol,UISearchBarDelegate {
    var showEmtpy: Bool{
        get {
            return dataSouce.count == 0
        }
    }
    func configEmptyView() -> UIView? {
        let view=Bundle.main.loadNibNamed("NoOrderView", owner: nil, options: nil)?[0]as?UIView
        view?.height=tableView.frame.height-(self.navigationController?.navigationBar.height)!-kStatusBarHeight
        view?.width=screenW
        
        return view
    }
    var keyword:String!
    var searchBar:UISearchBar!
    var orderStatus:Int!
    var pageNo:Int=1
    var limit:Int=10
    var dataSouce=[mOrder]()
    var orders=[mOrder]()
    var order:mOrder!
    var jsonStr:JSON!
    var startDate:Date!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch orderStatus {
        case 0:
            self.title="最新工单"
        case 1:
            self.title="昨日工单"
        case 2:
            self.title="质保工单"
        case 3:
            self.title="远程费工单"
        case 4:
            self.title="留言工单"
        case 5:
            self.title="区域无师傅工单"
        case 6:
            self.title="完成工单"
        case 7:
            self.title="已派未接工单"
        case 9:
            self.title="已接单待服务"
        case 10:
            self.title="远程费申请待审核"
        case 11:
            self.title="工厂待处理仲裁"
        case 12:
            self.title="师傅待处理仲裁"
        case 13:
            self.title="平台所有工单"
        case 14:
            self.title="待完结工单"
        default:
            self.title="配件工单"
            break
        }
        initSearchBar()
        tableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "re")
        //        tableView.register(UINib(nibName: "OrderHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "header")
        //        tableView.register(UINib(nibName: "OrderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "footer")
        //        tableView.separatorStyle = .none
        tableView.separatorInset=UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.setEmtpyViewDelegate(target: self)
        tableView.backgroundColor = "#F0F0F0".color()
        tableView.separatorStyle = .none
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNo = 1
            strongSelf.tableView.mj_footer!.state = .idle
            strongSelf.tableView.mj_header!.endRefreshing()
            HUD.show()
            strongSelf.loadData(orderStatus: strongSelf.orderStatus)
        })
        
        tableView.mj_header = header;
        
        let footer = TTRefreshFooter  {  [weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNo = strongSelf.pageNo + 1
            strongSelf.loadData(orderStatus: strongSelf.orderStatus)
        }
        
        tableView.mj_footer = footer
        tableView.mj_footer!.isHidden = false
    }
    init(status:Int){
        super.init(style: UITableView.Style.plain)
        self.orderStatus=status
        loadData(orderStatus: orderStatus)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:搜索
    func initSearchBar() {
        searchBar = UISearchBar()
        searchBar.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        searchBar.delegate = self
        searchBar.placeholder = "请输入工单号搜索"
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
        pageNo=1
        keyword=searchBar.text
        loadData(orderStatus: orderStatus)
    }
    //MARK:最新工单
    @objc func loadData(orderStatus:Int){
        //        "UserID":"",
        //        "State":"",
        //        "OrderID":"",
        //        "TypeID":"",
        //        "CreateDate":"",
        //        "partsIs":"",
        //        "messageIs":"",
        
        var d = [
            
            "page":"\(pageNo)",
            "limit":"\(limit)"
            
            ] as [String:Any]
        if keyword != nil {
            d["OrderID"]=keyword
        }
        switch orderStatus {
        case 0://最新工单
            d["CreateDate"]=getTimestamp()
        case 1://昨日工单
            d["StartTime"]=getLastDay(nowTime())
            d["EndTime"]=nowTime()
        case 2://质保工单
            d["TypeID"]="3"
        case 3://远程费工单
            d["State"]="9"
        case 4://留言工单
            d["messageIs"]="1"
        case 5://区域无师傅
            break
        case 6://完成工单
            d["State"]="7"
        case 7://已派未接单
            d["State"]="1"
            d["SendUserIs"]="1"
        case 9://已接待服务
            d["State"]="2"
        case 10://远程费工单
            d["State"]="9"
        case 11://工厂待处理仲裁
            break
        case 12://师傅待处理仲裁
            break
        case 13://平台所有工单
            break
        case 14:
            d["State"]="5"
        default://配件工单
            d["partsIs"]="1"
            break
        }
        print(d)
        AlamofireHelper.post(url: GetOrderInfoList2, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            
            if ss.pageNo == 1{ ss.dataSouce.removeAll()}
            
            if ss.tableView.mj_footer!.isRefreshing {
                ss.tableView.mj_footer!.endRefreshing()
                
            }
            if res["StatusCode"].intValue==200{
                ss.orders=res["Data"]["data"].arrayValue.compactMap({ mOrder(json: $0)})
                if ss.orders.count>0 {
                    if ss.tableView.mj_footer!.isHidden && ss.orders.count > 0 {
                        ss.tableView.mj_footer!.isHidden = false
                    }
                    ss.dataSouce.insert(contentsOf: ss.orders, at: ss.dataSouce.count)
                    if ss.orders.count < 10 {
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSouce.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "re") as! OrderTableViewCell
        let item=dataSouce[indexPath.row]
        cell.lb_time.text=Date.dateFormatterWithString(item.CreateDate!.replacingOccurrences(of: "T", with: " "))
        cell.lb_status.text="\(item.TypeName!)/\(item.GuaranteeStr!)"
        cell.lb_orderid.text="工单号：\(item.Id)"
        cell.lb_distance.text="距离：\(item.Distance)km"
        cell.lb_fdr.text="发单人：\(item.InvoiceName ?? "")"
        cell.lb_state.text="\(item.StateStr ?? "")"
        cell.lb_orderid.isHidden=false
        cell.lb_distance.isHidden=true
        cell.iv_pos.isHidden=true
        
        cell.lb_content.text="\(item.BrandName!)  \(item.SubCategoryName!)  \(item.ProductType!)"
        if item.TypeID==1{
            cell.lb_memo.text="故障：\(item.Memo!)"
        }else{
            cell.lb_memo.text="备注：\(item.Memo!)"
        }
        //        cell.lb_status.layer.cornerRadius=5
        cell.uv_card.layer.cornerRadius=5
        cell.lb_addr.text="地址：\(item.Address ?? "")"
        cell.selectionStyle = .none
        let tap=UITapGestureRecognizer(target: self, action: #selector(zhuanpai(ges:)))
        cell.iv_join.addGestureRecognizer(tap)
        tap.view!.tag=indexPath.row
        
        let tap1=UITapGestureRecognizer(target: self, action: #selector(zhipai(ges:)))
        cell.iv_phone.addGestureRecognizer(tap1)
        tap1.view!.tag=indexPath.row
        if item.SendUser!.isEmpty{
            cell.iv_phone.isHidden=false
            cell.iv_join.isHidden=true
        }else{
            cell.iv_phone.isHidden=true
            cell.iv_join.isHidden=false
        }
        
        return cell
    }
    //MARK:转派
    @objc func zhuanpai(ges:UITapGestureRecognizer){
        let item=dataSouce[ges.view!.tag]
        self.navigationController?.pushViewController(SFTableViewController(orderid: "\(item.OrderID)",type:"转派"), animated: true)
    }
    //MARK:指派
    @objc func zhipai(ges:UITapGestureRecognizer){
        let item=dataSouce[ges.view!.tag]
        self.navigationController?.pushViewController(SFTableViewController(orderid: "\(item.OrderID)",type:"指派"), animated: true)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item=dataSouce[indexPath.row]
        self.navigationController?.pushViewController(PageViewController(index: 0,orderid: "\(item.OrderID)"), animated: true)
    }
    //MARK:按钮样式
    func buttonStyle(btn:UIButton){
        btn.border(color: UIColor.lightGray, width: 1, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 5)
        btn.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        btn.contentEdgeInsets=UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        btn.snp.makeConstraints{(mask) in
            mask.height.equalTo(30)
        }
    }
    
    //MARK:查看详情
    @objc func seedetail(sender:UIButton!){
        print(sender.tag)
        
    }
}

struct mOrder {
    var SendOrderList = [mSendOrderList]()
    var AppointmentMessage: String?
    var Id: Int = 0
    var QuaMoney: Int = 0
    var Accessory: String?
    var AppraiseDate: String?
    var FactoryComplaint: String?
    var EndRemark: String?
    var IsPressFactory: String?
    var BrandName: String?
    var BeyondDistance: String?
    var DistanceTureOrFalse: Bool?
    var Extra: String?
    var Distance: Int = 0
    var Address: String?
    var Dimension: String?
    var OrderID: Int = 0
    var SettlementTime: String?
    var ReceiveOrderDate: String?
    var ExtraTime: String?
    var IsReturn: String?
    var SubCategoryName: String?
    var Longitude: String?
    var SettlementMoney: Int = 0
    var BeyondMoney: Double = 0
    var IsSettlement: String?
    var limit: Int = 0
    var IsUse: String?
    var IsCall: String?
    var BrandID: Int = 0
    var AccessoryMemo: String?
    var IsLook: String?
    var ProductTypeID: String?
    var FIsLook: String?
    var MallID: Int = 0
    var BeyondID: Int = 0
    var Version: Int = 0
    var AccessoryMoney: Int = 0
    var ApplyCancel: String?
    var UpdateTime: String?
    var CategoryName: String?
    var AccessorySequency: String?
    var FactoryApplyState: String?
    var DistrictCode: String?
    var OrderMoney: Double = 0
    var terraceMoney: Double = 0
    var TypeName: String?
    var AccessorySearchState: String?
    var AccessoryIsPay: String?
    var WorkerComplaint: String?
    var AccessoryState: String?
    var CategoryID: Int = 0
    var OrderSource: String?
    var IsRecevieGoods: String?
    var ReturnAccessory: String?
    var IsExtraTime: String?
    var AccessoryApplyState: String?
    var Guarantee: String?
    var GuaranteeStr: String?{
        get{
            if self.Guarantee=="Y"{
                return "保内"
            }else{
                return "保外"
            }
        }
    }
    var AccessorySendState: String?
    var QApplyNum: Int = 0
    var SubTypeName: String?
    var InvoiceName: String?
    var ExpressNo: String?
    var State: String?
    var StateStr: String?{
        get{
            var status=""
            switch State!{
            case "-2":
                status="申请废除工单"
            case "-1":
                status="退单处理"
            case "0":
                status="待审核"
            case "1":
                status="待接单"
            case "2":
                status="已接单待联系客户"
            case "3":
                status="已联系客户待服务"
            case "4":
                status="服务中"
            case "5":
                status="服务完成"
            case "6":
                status="待评价"
            case "7":
                status="已完成"
            case "8":
                status="服务中待返件"
            case "9":
                status="远程费待审核"
            default:
                status="服务中"
            }
            return status
        }
    }
    var page: Int = 0
    var PostMoney: Int = 0
    var PostPayType: String?
    var IsPay: String?
    var LateTime: String?
    var Service: String?
    var SendAddress: String?
    var SendOrderMsg: String?
    var OrgAppraise: String?
    var SubTypeID: Int = 0
    var NewMoney: String?
    var IsLate: String?
    var ApplyNum: Int = 0
    var BeyondState: String?
    var SubCategoryID: Int = 0
    var ThirdPartyNo: String?
    var AreaCode: String?
    var ServiceApplyState: String?
    var Num: Int = 0
    var Grade3: Int = 0
    var IsSendRepair: String?
    var CreateDate: String?
    var RecycleOrderHour: Int = 0
    var ReturnAccessoryMsg: String?
    var AccessoryRefuseState: String?
    var SendUser: String?
    var ProductType: String?
    var ServiceApplyDate: String?
    var AccessoryApplyDate: String?
    var SendOrderState: String?
    var OrderSort: String?
    var StateHtml: String?
    var ExtraFee: Int = 0
    var UserID: String?
    var Grade: Int = 0
    var OrderAccessoryStr: String?
    var AppointmentRefuseState: String?
    var RepairCompleteDate: String?
    var Grade2: Int = 0
    var OrderPayStr: String?
    var OrgSendUser: String?
    var Grade1: Int = 0
    var ProvinceCode: String?
    var Memo: String?
    var TypeID: Int = 0
    var AccessoryServiceMoney: Int = 0
    var AppointmentState: String?
    var InitMoney: Int = 0
    var UserName: String?
    var CityCode: String?
    var AddressBack: String?
    var Phone: String?
    var ServiceMoney: Int = 0
    var AudDate: String?
    var LoginUser: String?
    
    init(json: JSON) {
        SendOrderList = json["SendOrderList"].arrayValue.compactMap({ mSendOrderList(json: $0)})
        AppointmentMessage = json["AppointmentMessage"].stringValue
        Id = json["Id"].intValue
        QuaMoney = json["QuaMoney"].intValue
        Accessory = json["Accessory"].stringValue
        AppraiseDate = json["AppraiseDate"].stringValue
        FactoryComplaint = json["FactoryComplaint"].stringValue
        EndRemark = json["EndRemark"].stringValue
        IsPressFactory = json["IsPressFactory"].stringValue
        BrandName = json["BrandName"].stringValue
        BeyondDistance = json["BeyondDistance"].stringValue
        DistanceTureOrFalse = json["DistanceTureOrFalse"].boolValue
        Extra = json["Extra"].stringValue
        Distance = json["Distance"].intValue
        Address = json["Address"].stringValue
        Dimension = json["Dimension"].stringValue
        OrderID = json["OrderID"].intValue
        SettlementTime = json["SettlementTime"].stringValue
        ReceiveOrderDate = json["ReceiveOrderDate"].stringValue
        ExtraTime = json["ExtraTime"].stringValue
        IsReturn = json["IsReturn"].stringValue
        SubCategoryName = json["SubCategoryName"].stringValue
        Longitude = json["Longitude"].stringValue
        SettlementMoney = json["SettlementMoney"].intValue
        BeyondMoney = json["BeyondMoney"].doubleValue
        IsSettlement = json["IsSettlement"].stringValue
        limit = json["limit"].intValue
        IsUse = json["IsUse"].stringValue
        IsCall = json["IsCall"].stringValue
        BrandID = json["BrandID"].intValue
        AccessoryMemo = json["AccessoryMemo"].stringValue
        IsLook = json["IsLook"].stringValue
        ProductTypeID = json["ProductTypeID"].stringValue
        FIsLook = json["FIsLook"].stringValue
        MallID = json["MallID"].intValue
        BeyondID = json["BeyondID"].intValue
        Version = json["Version"].intValue
        AccessoryMoney = json["AccessoryMoney"].intValue
        ApplyCancel = json["ApplyCancel"].stringValue
        UpdateTime = json["UpdateTime"].stringValue
        CategoryName = json["CategoryName"].stringValue
        AccessorySequency = json["AccessorySequency"].stringValue
        FactoryApplyState = json["FactoryApplyState"].stringValue
        DistrictCode = json["DistrictCode"].stringValue
        OrderMoney = json["OrderMoney"].doubleValue
        terraceMoney = json["terraceMoney"].doubleValue
        TypeName = json["TypeName"].stringValue
        AccessorySearchState = json["AccessorySearchState"].stringValue
        AccessoryIsPay = json["AccessoryIsPay"].stringValue
        WorkerComplaint = json["WorkerComplaint"].stringValue
        AccessoryState = json["AccessoryState"].stringValue
        CategoryID = json["CategoryID"].intValue
        OrderSource = json["OrderSource"].stringValue
        IsRecevieGoods = json["IsRecevieGoods"].stringValue
        ReturnAccessory = json["ReturnAccessory"].stringValue
        IsExtraTime = json["IsExtraTime"].stringValue
        AccessoryApplyState = json["AccessoryApplyState"].stringValue
        Guarantee = json["Guarantee"].stringValue
        AccessorySendState = json["AccessorySendState"].stringValue
        QApplyNum = json["QApplyNum"].intValue
        SubTypeName = json["SubTypeName"].stringValue
        InvoiceName = json["InvoiceName"].stringValue
        ExpressNo = json["ExpressNo"].stringValue
        State = json["State"].stringValue
        page = json["page"].intValue
        PostMoney = json["PostMoney"].intValue
        PostPayType = json["PostPayType"].stringValue
        IsPay = json["IsPay"].stringValue
        LateTime = json["LateTime"].stringValue
        Service = json["Service"].stringValue
        SendAddress = json["SendAddress"].stringValue
        SendOrderMsg = json["SendOrderMsg"].stringValue
        OrgAppraise = json["OrgAppraise"].stringValue
        SubTypeID = json["SubTypeID"].intValue
        NewMoney = json["NewMoney"].stringValue
        IsLate = json["IsLate"].stringValue
        ApplyNum = json["ApplyNum"].intValue
        BeyondState = json["BeyondState"].stringValue
        SubCategoryID = json["SubCategoryID"].intValue
        ThirdPartyNo = json["ThirdPartyNo"].stringValue
        AreaCode = json["AreaCode"].stringValue
        ServiceApplyState = json["ServiceApplyState"].stringValue
        Num = json["Num"].intValue
        Grade3 = json["Grade3"].intValue
        IsSendRepair = json["IsSendRepair"].stringValue
        CreateDate = json["CreateDate"].stringValue
        RecycleOrderHour = json["RecycleOrderHour"].intValue
        ReturnAccessoryMsg = json["ReturnAccessoryMsg"].stringValue
        AccessoryRefuseState = json["AccessoryRefuseState"].stringValue
        SendUser = json["SendUser"].stringValue
        ProductType = json["ProductType"].stringValue
        ServiceApplyDate = json["ServiceApplyDate"].stringValue
        AccessoryApplyDate = json["AccessoryApplyDate"].stringValue
        SendOrderState = json["SendOrderState"].stringValue
        OrderSort = json["OrderSort"].stringValue
        StateHtml = json["StateHtml"].stringValue
        ExtraFee = json["ExtraFee"].intValue
        UserID = json["UserID"].stringValue
        Grade = json["Grade"].intValue
        OrderAccessoryStr = json["OrderAccessoryStr"].stringValue
        AppointmentRefuseState = json["AppointmentRefuseState"].stringValue
        RepairCompleteDate = json["RepairCompleteDate"].stringValue
        Grade2 = json["Grade2"].intValue
        OrderPayStr = json["OrderPayStr"].stringValue
        OrgSendUser = json["OrgSendUser"].stringValue
        Grade1 = json["Grade1"].intValue
        ProvinceCode = json["ProvinceCode"].stringValue
        Memo = json["Memo"].stringValue
        TypeID = json["TypeID"].intValue
        AccessoryServiceMoney = json["AccessoryServiceMoney"].intValue
        AppointmentState = json["AppointmentState"].stringValue
        InitMoney = json["InitMoney"].intValue
        UserName = json["UserName"].stringValue
        CityCode = json["CityCode"].stringValue
        AddressBack = json["AddressBack"].stringValue
        Phone = json["Phone"].stringValue
        ServiceMoney = json["ServiceMoney"].intValue
        AudDate = json["AudDate"].stringValue
        LoginUser = json["LoginUser"].stringValue
    }
}

struct mSendOrderList {
    var Version: Int = 0
    var UserID: String?
    var Address: String?
    var CityCode: String?
    var SubTypeID: Int = 0
    var Memo: String?
    var Guarantee: String?
    var SubTypeName: String?
    var State: String?
    var Phone: String?
    var Id: Int = 0
    var CreateDate: String?
    var CategoryName: String?
    var SendID: Int = 0
    var OrderID: Int = 0
    var AreaCode: String?
    var ServiceDate: String?
    var ProductType: String?
    var limit: Int = 0
    var BrandID: Int = 0
    var IsUse: String?
    var LoginUser: String?
    var page: Int = 0
    var UserName: String?
    var AppointmentState: String?
    var CategoryID: Int = 0
    var AppointmentMessage: String?
    var ProvinceCode: String?
    var UpdateDate: String?
    var BrandName: String?
    var ServiceDate2: String?
    
    init(json: JSON) {
        Version = json["Version"].intValue
        UserID = json["UserID"].stringValue
        Address = json["Address"].stringValue
        CityCode = json["CityCode"].stringValue
        SubTypeID = json["SubTypeID"].intValue
        Memo = json["Memo"].stringValue
        Guarantee = json["Guarantee"].stringValue
        SubTypeName = json["SubTypeName"].stringValue
        State = json["State"].stringValue
        Phone = json["Phone"].stringValue
        Id = json["Id"].intValue
        CreateDate = json["CreateDate"].stringValue
        CategoryName = json["CategoryName"].stringValue
        SendID = json["SendID"].intValue
        OrderID = json["OrderID"].intValue
        AreaCode = json["AreaCode"].stringValue
        ServiceDate = json["ServiceDate"].stringValue
        ProductType = json["ProductType"].stringValue
        limit = json["limit"].intValue
        BrandID = json["BrandID"].intValue
        IsUse = json["IsUse"].stringValue
        LoginUser = json["LoginUser"].stringValue
        page = json["page"].intValue
        UserName = json["UserName"].stringValue
        AppointmentState = json["AppointmentState"].stringValue
        CategoryID = json["CategoryID"].intValue
        AppointmentMessage = json["AppointmentMessage"].stringValue
        ProvinceCode = json["ProvinceCode"].stringValue
        UpdateDate = json["UpdateDate"].stringValue
        BrandName = json["BrandName"].stringValue
        ServiceDate2 = json["ServiceDate2"].stringValue
    }
}
