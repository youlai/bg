//
//  OrderDetailViewController.swift
//  bg
//
//  Created by Apple on 2019/12/20.
//  Copyright © 2019 zhkj. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detail==nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "re") as! OrderDetailsCell
        cell.selectionStyle = .none
        if self.detail != nil{
            cell.filldata(order: self.detail.Data!)
        }
        cell.btn_modify.addTarget(self, action: #selector(changeMoney(sender:)), for: UIControl.Event.touchUpInside)
        cell.btn_close.addTarget(self, action: #selector(closeOrder(sender:)), for: UIControl.Event.touchUpInside)
        cell.btn_abolish.addTarget(self, action: #selector(abolishOrder(sender:)), for: UIControl.Event.touchUpInside)
        cell.btn_modify.tag=indexPath.row
        cell.btn_close.tag=indexPath.row
        cell.btn_abolish.tag=indexPath.row
        return cell
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var orderid:String!
    var money:String!
    var type:String!
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
        tableView.register(UINib(nibName: "OrderDetailsCell", bundle: nil), forCellReuseIdentifier: "re")
        tableView.separatorStyle = .none
        getOrderInfo()
    }
    //MARK:获取工单详情
        @objc func getOrderInfo(){
            let d = ["OrderID":orderid!]
            AlamofireHelper.post(url: GetOrderInfo, parameters: d , successHandler: {[weak self](res)in
                HUD.dismiss()
                guard let ss = self else {return}
                ss.detail=mOrderDetail.init(json: res)
                ss.tableView.reloadData()
            }){[weak self] (error) in
                HUD.dismiss()
                guard let ss = self else {return}
            }
        }
    //MARK:修改工单价格
    @objc func changeMoney(sender:UIButton){
        let alertController = UIAlertController(title: "修改工单价格", message: "", preferredStyle: UIAlertController.Style.alert);
        alertController.addTextField { (textField:UITextField!) -> Void in
            textField.placeholder = "请输入修改金额";
            textField.keyboardType = .numberPad
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil )
        let okAction = UIAlertAction(title: "确认", style: UIAlertAction.Style.default) { (ACTION) -> Void in
            let tf_money = alertController.textFields!.first! as UITextField
            self.money=tf_money.text!
            if self.money.isEmpty{
                HUD.showText("请输入金额")
                return
            }
            self.ToModifyOrderMoney()
        }
        alertController.addAction(cancelAction);
        alertController.addAction(okAction);
        self.present(alertController, animated: true, completion: nil)
    }
    //MARK:关闭工单
    @objc func closeOrder(sender:UIButton){
        let alertController = UIAlertController(title: "是否关闭工单", message: "", preferredStyle: UIAlertController.Style.alert);
        alertController.addTextField { (textField:UITextField!) -> Void in
            textField.placeholder = "请输入结算金额";
            textField.keyboardType = .numberPad
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil )
        let okAction = UIAlertAction(title: "确认", style: UIAlertAction.Style.default) { (ACTION) -> Void in
            let tf_money = alertController.textFields!.first! as UITextField
            self.money=tf_money.text!
            if self.money.isEmpty{
                HUD.showText("请输入金额")
                return
            }
            self.type="1"
            self.ToCloseOrAbolish()
        }
        alertController.addAction(cancelAction);
        alertController.addAction(okAction);
        self.present(alertController, animated: true, completion: nil)
    }
    //MARK:废除工单
    @objc func abolishOrder(sender:UIButton){
        let alertController = UIAlertController(title: "是否废除工单", message: "", preferredStyle: UIAlertController.Style.alert);
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil )
        let okAction = UIAlertAction(title: "确认", style: UIAlertAction.Style.default) { (ACTION) -> Void in
            self.type="1"
            self.money=""
            self.ToCloseOrAbolish()
        }
        alertController.addAction(cancelAction);
        alertController.addAction(okAction);
        self.present(alertController, animated: true, completion: nil)
    }
    @objc func ToModifyOrderMoney(){
        let d = ["UserID":UserID,
                 "orderMoney":money,
                 "OrderID":orderid,
            ] as! [String : String]
        AlamofireHelper.post(url: modifyOrderMoney, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                HUD.showText("修改成功")
                ss.getOrderInfo()
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    @objc func ToCloseOrAbolish(){
        let d = ["UserID":UserID,
                 "price":money,
                 "OrderID":orderid,
                 "Type":type//1关闭 2废除
            ] as! [String : String]
        AlamofireHelper.post(url: CloseOrder, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                HUD.showText("操作成功")
                ss.getOrderInfo()
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
struct mOrderDetail {
    var StatusCode: Int = 0
    var Data: mData?
    var Info: String?
    
    init(json: JSON) {
        StatusCode = json["StatusCode"].intValue
        Data = mData(json: json["Data"])
        Info = json["Info"].stringValue
    }
}

struct mData {
    var SendAddress: String?
    var AccessoryAndServiceApplyDate: String?
    var RecycleOrderHour: Int = 0
    var ReturnAccessory: String?
    var CreateDate: String?
    var Extra: String?
    var OrderPayStr: String?
    var UserName: String?
    var IsReturn: String?
    var page: Int = 0
    var CityCode: String?
    var Accessory: String?
    var AppointmentMessage: String?
    var ThirdPartyNo: String?
    var OrderApplyState: String?
    var MallID: Int = 0
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
    var StateDescStr: String?{
        get{
            var desc=""
            switch State!{
            case "4":
                switch TypeID{
                case 1:
                    desc="可添加维修配件及直接完成工单"
                default:
                    desc="可根据用户需求增加相应的服务项目"
                }
            default:
                desc=""
            }
            return desc
        }
    }
    var OrderID: Int = 0
    var ProductTypeID: String?
    var Address: String?
    var AccessoryRefuseState: String?
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
    var MemoTitle: String?{
        get{
            if self.TypeID==2{
                return "备注"
            }else{
                return "故障描述"
            }
        }
    }
    var SendOrderList = [mSendOrderList]()
    var QuaMoney: Double = 0
    var ApplyNum: Int = 0
    var AppointmentRefuseState: String?
    var AccessoryIsPay: String?
    var ServiceApplyState: String?
    var ProductType: String?
    var BrandName: String?
    var CategoryID: Int = 0
    var AppointmentState: String?
    var UserID: String?
    var ProvinceCode: String?
    var AccessoryState: String?
    var AccessoryStateStr: String?{
        get{
            if self.AccessoryState=="0"{
                return "厂商寄件"
            }else if self.AccessoryState=="1"{
                return "师傅自购件"
            }else{
                return "用户自购件"
            }
        }
    }
    var UpdateTime: String?
    var FactoryApplyState: String?
    var Num: Int = 0
    var LoginUser: String?
    var AccessoryMoney: Int = 0
    var AppraiseDate: String?
    var ExpressNo: String?
    var IsRecevieGoods: String?
    var NewMoney: String?
    var SendOrderState: String?
    var StarOrder: String?
    var AddressBack: String?
    var StateHtml: String?
    var Phone: String?
    var SettlementMoney: Int = 0
    var OrgAppraise: String?
    var DistrictCode: String?
    var Dimension: String?
    var AccessoryMemo: String?
    var Longitude: String?
    var Memo: String?
    var AccessorySequency: String?
    var AccessorySearchState: String?
    var ReturnAccessoryMsg: String?
    var PostMoney: Int = 0
    var Grade2: Int = 0
    var IsSettlement: String?
    var IsUse: String?
    var AccessoryAndServiceApplyState: String?
    var AccessoryAndServiceApplyStateStr: String?{
        get{
            if self.AccessoryAndServiceApplyState=="-1"{
                return "已拒绝"
            }else if self.AccessoryAndServiceApplyState=="0"{
                return "审核中"
            }else{
                return "已通过"
            }
        }
    }
    var IsPressFactory: String?
    var Service: String?
    var CategoryName: String?
    var Version: Int = 0
    var AreaCode: String?
    var OrderMoney: Double = 0
    var terraceMoney: Double = 0
    var LateTime: String?
    var AccessorySendState: String?
    var BeyondID: Int = 0
    var ApplyCancel: String?
    var SubTypeID: Int = 0
    var OrderAccessoryStr: String?
    var QApplyNum: Int = 0
    var SettlementTime: String?
    var FactoryComplaint: String?
    var InitMoney: Int = 0
    var PostPayType: String?
    var PostPayTypeStr: String?{
        get{
            if self.PostPayType=="1"{
                return "厂商到付"
            }else{
                return "维修商现付"
            }
        }
    }
    var BeyondDistance: String?
    var ReturnaccessoryImg = [mReturnaccessoryImg]()
    var OrderBeyondImg = [mOrderBeyondImg]()
    var OrderAccessroyDetail = [mOrderAccessroyDetail]()
    var OrderServiceDetail = [mOrderServiceDetail]()
    var LeavemessageList = [mLeavemessageList]()
    var WorkerComplaint: String?
    var ExtraTime: String?
    var AccessorySearchStateList: String?
    var SubCategoryID: Int = 0
    var SubTypeName: String?
    var DistanceTureOrFalse: Bool = false
    var Grade1: Int = 0
    var BeyondState: String?
    var BeyondStateStr: String?{
        get{
            if self.BeyondState=="-1"{
                return "已拒绝"
            }else if self.BeyondState=="0"{
                return "审核中"
            }else if self.BeyondState=="1"{
                return "已通过"
            }else{
                return "未申请"
            }
        }
    }
    var ExtraFee: Int = 0
    var OrderSort: String?
    var ServiceMoney: Int = 0
    var RepairCompleteDate: String?
    var IsSendRepair: String?
    var FStarOrder: String?
    var SubCategoryName: String?
    var limit: Int = 0
    var FIsLook: String?
    var OrderSource: String?
    var Distance: Float = 0.0
    var IsLate: String?
    var AudDate: String?
    var IsExtraTime: String?
    var AccessoryApplyState: String?
    var SendOrderMsg: String?
    var Grade3: Int = 0
    var Grade: Int = 0
    var BrandID: Int = 0
    var TypeName: String?
    var TypeID: Int = 0
    var AccessoryApplyDate: String?
    var IsLook: String?
    var IsPay: String?
    var ReceiveOrderDate: String?
    var SendUser: String?
    var BeyondMoney: Double = 0
    var Id: Int = 0
    var OrgSendUser: String?
    var EndRemark: String?
    var ServiceApplyDate: String?
    var AccessoryServiceMoney: Int = 0
    
    init(json: JSON) {
        SendAddress = json["SendAddress"].stringValue
        AccessoryAndServiceApplyDate = json["AccessoryAndServiceApplyDate"].stringValue
        RecycleOrderHour = json["RecycleOrderHour"].intValue
        ReturnAccessory = json["ReturnAccessory"].stringValue
        CreateDate = json["CreateDate"].stringValue
        Extra = json["Extra"].stringValue
        OrderPayStr = json["OrderPayStr"].stringValue
        UserName = json["UserName"].stringValue
        IsReturn = json["IsReturn"].stringValue
        page = json["page"].intValue
        CityCode = json["CityCode"].stringValue
        Accessory = json["Accessory"].stringValue
        AppointmentMessage = json["AppointmentMessage"].stringValue
        ThirdPartyNo = json["ThirdPartyNo"].stringValue
        OrderApplyState = json["OrderApplyState"].stringValue
        MallID = json["MallID"].intValue
        State = json["State"].stringValue
        OrderID = json["OrderID"].intValue
        ProductTypeID = json["ProductTypeID"].stringValue
        Address = json["Address"].stringValue
        AccessoryRefuseState = json["AccessoryRefuseState"].stringValue
        Guarantee = json["Guarantee"].stringValue
        SendOrderList = json["SendOrderList"].arrayValue.compactMap({ mSendOrderList(json: $0)})
        OrderBeyondImg = json["OrderBeyondImg"].arrayValue.compactMap({ mOrderBeyondImg(json: $0)})
        ReturnaccessoryImg = json["ReturnaccessoryImg"].arrayValue.compactMap({ mReturnaccessoryImg(json: $0)})
        OrderServiceDetail = json["OrderServiceDetail"].arrayValue.compactMap({ mOrderServiceDetail(json: $0)})
        OrderAccessroyDetail = json["OrderAccessroyDetail"].arrayValue.compactMap({ mOrderAccessroyDetail(json: $0)})
        LeavemessageList = json["LeavemessageList"].arrayValue.compactMap({ mLeavemessageList(json: $0)})
        QuaMoney = json["QuaMoney"].doubleValue
        ApplyNum = json["ApplyNum"].intValue
        AppointmentRefuseState = json["AppointmentRefuseState"].stringValue
        AccessoryIsPay = json["AccessoryIsPay"].stringValue
        ServiceApplyState = json["ServiceApplyState"].stringValue
        ProductType = json["ProductType"].stringValue
        BrandName = json["BrandName"].stringValue
        CategoryID = json["CategoryID"].intValue
        AppointmentState = json["AppointmentState"].stringValue
        UserID = json["UserID"].stringValue
        ProvinceCode = json["ProvinceCode"].stringValue
        AccessoryState = json["AccessoryState"].stringValue
        UpdateTime = json["UpdateTime"].stringValue
        FactoryApplyState = json["FactoryApplyState"].stringValue
        Num = json["Num"].intValue
        LoginUser = json["LoginUser"].stringValue
        AccessoryMoney = json["AccessoryMoney"].intValue
        AppraiseDate = json["AppraiseDate"].stringValue
        ExpressNo = json["ExpressNo"].stringValue
        IsRecevieGoods = json["IsRecevieGoods"].stringValue
        NewMoney = json["NewMoney"].stringValue
        SendOrderState = json["SendOrderState"].stringValue
        StarOrder = json["StarOrder"].stringValue
        AddressBack = json["AddressBack"].stringValue
        StateHtml = json["StateHtml"].stringValue
        Phone = json["Phone"].stringValue
        SettlementMoney = json["SettlementMoney"].intValue
        OrgAppraise = json["OrgAppraise"].stringValue
        DistrictCode = json["DistrictCode"].stringValue
        Dimension = json["Dimension"].stringValue
        AccessoryMemo = json["AccessoryMemo"].stringValue
        Longitude = json["Longitude"].stringValue
        Memo = json["Memo"].stringValue
        AccessorySequency = json["AccessorySequency"].stringValue
        AccessorySearchState = json["AccessorySearchState"].stringValue
        ReturnAccessoryMsg = json["ReturnAccessoryMsg"].stringValue
        PostMoney = json["PostMoney"].intValue
        Grade2 = json["Grade2"].intValue
        IsSettlement = json["IsSettlement"].stringValue
        IsUse = json["IsUse"].stringValue
        AccessoryAndServiceApplyState = json["AccessoryAndServiceApplyState"].stringValue
        IsPressFactory = json["IsPressFactory"].stringValue
        Service = json["Service"].stringValue
        CategoryName = json["CategoryName"].stringValue
        Version = json["Version"].intValue
        AreaCode = json["AreaCode"].stringValue
        OrderMoney = json["OrderMoney"].doubleValue
        terraceMoney = json["terraceMoney"].doubleValue
        LateTime = json["LateTime"].stringValue
        AccessorySendState = json["AccessorySendState"].stringValue
        BeyondID = json["BeyondID"].intValue
        ApplyCancel = json["ApplyCancel"].stringValue
        SubTypeID = json["SubTypeID"].intValue
        OrderAccessoryStr = json["OrderAccessoryStr"].stringValue
        QApplyNum = json["QApplyNum"].intValue
        SettlementTime = json["SettlementTime"].stringValue
        FactoryComplaint = json["FactoryComplaint"].stringValue
        InitMoney = json["InitMoney"].intValue
        PostPayType = json["PostPayType"].stringValue
        BeyondDistance = json["BeyondDistance"].stringValue
        WorkerComplaint = json["WorkerComplaint"].stringValue
        ExtraTime = json["ExtraTime"].stringValue
        AccessorySearchStateList = json["AccessorySearchStateList"].stringValue
        SubCategoryID = json["SubCategoryID"].intValue
        SubTypeName = json["SubTypeName"].stringValue
        DistanceTureOrFalse = json["DistanceTureOrFalse"].boolValue
        Grade1 = json["Grade1"].intValue
        BeyondState = json["BeyondState"].stringValue
        ExtraFee = json["ExtraFee"].intValue
        OrderSort = json["OrderSort"].stringValue
        ServiceMoney = json["ServiceMoney"].intValue
        RepairCompleteDate = json["RepairCompleteDate"].stringValue
        IsSendRepair = json["IsSendRepair"].stringValue
        FStarOrder = json["FStarOrder"].stringValue
        SubCategoryName = json["SubCategoryName"].stringValue
        limit = json["limit"].intValue
        FIsLook = json["FIsLook"].stringValue
        OrderSource = json["OrderSource"].stringValue
        Distance = json["Distance"].floatValue
        IsLate = json["IsLate"].stringValue
        AudDate = json["AudDate"].stringValue
        IsExtraTime = json["IsExtraTime"].stringValue
        AccessoryApplyState = json["AccessoryApplyState"].stringValue
        SendOrderMsg = json["SendOrderMsg"].stringValue
        Grade3 = json["Grade3"].intValue
        Grade = json["Grade"].intValue
        BrandID = json["BrandID"].intValue
        TypeName = json["TypeName"].stringValue
        TypeID = json["TypeID"].intValue
        AccessoryApplyDate = json["AccessoryApplyDate"].stringValue
        IsLook = json["IsLook"].stringValue
        IsPay = json["IsPay"].stringValue
        ReceiveOrderDate = json["ReceiveOrderDate"].stringValue
        SendUser = json["SendUser"].stringValue
        BeyondMoney = json["BeyondMoney"].doubleValue
        Id = json["Id"].intValue
        OrgSendUser = json["OrgSendUser"].stringValue
        EndRemark = json["EndRemark"].stringValue
        ServiceApplyDate = json["ServiceApplyDate"].stringValue
        AccessoryServiceMoney = json["AccessoryServiceMoney"].intValue
    }
}
struct mOrderBeyondImg {
    var Version: Int = 0
    var Url: String?
    var OrderID: Int = 0
    var OrderBeyondImgID: Int = 0
    var limit: Int = 0
    var page: Int = 0
    var Id: Int = 0
    var IsUse: String?
    var CreateTime: String?
    
    init(json: JSON) {
        Version = json["Version"].intValue
        Url = json["Url"].stringValue
        OrderID = json["OrderID"].intValue
        OrderBeyondImgID = json["OrderBeyondImgID"].intValue
        limit = json["limit"].intValue
        page = json["page"].intValue
        Id = json["Id"].intValue
        IsUse = json["IsUse"].stringValue
        CreateTime = json["CreateTime"].stringValue
    }
}
struct mReturnaccessoryImg {
    var Url: String?
    var IsUse: String?
    var Id: Int = 0
    var Relation: String?
    var page: Int = 0
    var OrderID: Int = 0
    var Version: Int = 0
    var ReturnAccessoryID: Int = 0
    var limit: Int = 0
    var CeateTime: String?

    init(json: JSON) {
        Url = json["Url"].stringValue
        IsUse = json["IsUse"].stringValue
        Id = json["Id"].intValue
        Relation = json["Relation"].stringValue
        page = json["page"].intValue
        OrderID = json["OrderID"].intValue
        Version = json["Version"].intValue
        ReturnAccessoryID = json["ReturnAccessoryID"].intValue
        limit = json["limit"].intValue
        CeateTime = json["CeateTime"].stringValue
    }
}
struct mOrderAccessroyDetail {
    var Relation: String?
    var NeedPlatformAuth: String?
    var OrderID: Int = 0
    var Version: Int = 0
    var page: Int = 0
    var SizeID: Int = 0
    var ApplyNum: Int = 0
    var Quantity: Int = 0
    var IsUse: String?
    var QApplyNum: Int = 0
    var AccessoryState: String?
    var ExpressNo: String?
    var IsPay: String?
    var limit: Int = 0
    var Photo2: String?
    var Photo1: String?
    var State: String?
    var SendState: String?
    var CreateTime: String?
    var FCategoryID: Int = 0
    var Id: Int = 0
    var FAccessoryID: Int = 0
    var Price: Int = 0
    var TypeID: String?
    var FAccessoryName: String?
    var AccessoryID: Int = 0
    var DiscountPrice: Int = 0
    
    init(json: JSON) {
        Relation = json["Relation"].stringValue
        NeedPlatformAuth = json["NeedPlatformAuth"].stringValue
        OrderID = json["OrderID"].intValue
        Version = json["Version"].intValue
        page = json["page"].intValue
        SizeID = json["SizeID"].intValue
        ApplyNum = json["ApplyNum"].intValue
        Quantity = json["Quantity"].intValue
        IsUse = json["IsUse"].stringValue
        QApplyNum = json["QApplyNum"].intValue
        AccessoryState = json["AccessoryState"].stringValue
        ExpressNo = json["ExpressNo"].stringValue
        IsPay = json["IsPay"].stringValue
        limit = json["limit"].intValue
        Photo2 = json["Photo2"].stringValue
        Photo1 = json["Photo1"].stringValue
        State = json["State"].stringValue
        SendState = json["SendState"].stringValue
        CreateTime = json["CreateTime"].stringValue
        FCategoryID = json["FCategoryID"].intValue
        Id = json["Id"].intValue
        FAccessoryID = json["FAccessoryID"].intValue
        Price = json["Price"].intValue
        TypeID = json["TypeID"].stringValue
        FAccessoryName = json["FAccessoryName"].stringValue
        AccessoryID = json["AccessoryID"].intValue
        DiscountPrice = json["DiscountPrice"].intValue
    }
}
struct mOrderServiceDetail {
    var ServiceName: String?
    var BrandID: Int = 0
    var OrderID: Int = 0
    var Price: Int = 0
    var Version: Int = 0
    var Relation: String?
    var SNeedPlatformAuth: String?
    var limit: Int = 0
    var IsUse: String?
    var OrderServiceID: Int = 0
    var page: Int = 0
    var State: String?
    var CategoryID: Int = 0
    var SizeID: Int = 0
    var ServiceID: Int = 0
    var TypeID: String?
    var IsPay: String?
    var DiscountPrice: Int = 0
    var CreateTime: String?
    var Id: Int = 0
    
    init(json: JSON) {
        ServiceName = json["ServiceName"].stringValue
        BrandID = json["BrandID"].intValue
        OrderID = json["OrderID"].intValue
        Price = json["Price"].intValue
        Version = json["Version"].intValue
        Relation = json["Relation"].stringValue
        SNeedPlatformAuth = json["SNeedPlatformAuth"].stringValue
        limit = json["limit"].intValue
        IsUse = json["IsUse"].stringValue
        OrderServiceID = json["OrderServiceID"].intValue
        page = json["page"].intValue
        State = json["State"].stringValue
        CategoryID = json["CategoryID"].intValue
        SizeID = json["SizeID"].intValue
        ServiceID = json["ServiceID"].intValue
        TypeID = json["TypeID"].stringValue
        IsPay = json["IsPay"].stringValue
        DiscountPrice = json["DiscountPrice"].intValue
        CreateTime = json["CreateTime"].stringValue
        Id = json["Id"].intValue
    }
}

struct OrderAccessoryAndService{
    var OrderServiceStr: String?
    var OrderAccessoryStr: String?
    var SizeID: String?
    var AccessorySequency: String?
    var Money: String?
    var OrderID: String?
    
    init(json: JSON) {
        OrderServiceStr = json["OrderServiceStr"].stringValue
        OrderAccessoryStr = json["OrderAccessoryStr"].stringValue
        SizeID = json["SizeID"].stringValue
        AccessorySequency = json["AccessorySequency"].stringValue
        Money = json["Money"].stringValue
        OrderID = json["OrderID"].stringValue
    }}
struct mOrderAccessory {
    var OrderAccessory = [OrderAccessoryModel]()
    init(OrderAccessory:[OrderAccessoryModel]) {
        self.OrderAccessory=OrderAccessory
    }
}

struct OrderAccessoryModel {
    var State: String?
    var Price: Float = 0.0
    var Quantity: String?
    var Photo1: String?
    var DiscountPrice: Float = 0.0
    var SizeID: String?
    var IsPay: String?
    var FAccessoryName: String?
    var FCategoryID: String?
    var Relation: String?
    var SendState: String?
    var NeedPlatformAuth: String?
    var Photo2: String?
    var ExpressNo: String?
    var FAccessoryID: String?
    init(
    State: String?,
    Price: Float = 0.0,
    Quantity: String?,
    Photo1: String?,
    DiscountPrice: Float = 0.0,
    SizeID: String?,
    IsPay: String?,
    FAccessoryName: String?,
    FCategoryID: String?,
    Relation: String?,
    SendState: String?,
    NeedPlatformAuth: String?,
    Photo2: String?,
    ExpressNo: String?,
    FAccessoryID: String?) {
        self.State=State
        self.Price=Price
        self.Quantity=Quantity
        self.Photo1=Photo1
        self.Photo2=Photo2
        self.DiscountPrice=DiscountPrice
        self.SizeID=SizeID
        self.IsPay=IsPay
        self.FAccessoryName=FAccessoryName
        self.FAccessoryID=FAccessoryID
        self.FCategoryID=FCategoryID
        self.ExpressNo=ExpressNo
        self.NeedPlatformAuth=NeedPlatformAuth
        self.SendState=SendState
        self.Relation=Relation
    }
}
struct mOrderService {
    var OrderService = [OrderServiceModel]()
    init(OrderService:[OrderServiceModel]) {
        self.OrderService=OrderService
    }
}

struct OrderServiceModel {
    var DiscountPrice: String
    var IsPay: String
    var FServiceID: String
    var CategoryID: String
    var FServiceName: String
    var State: String
    var Price: String
    var SNeedPlatformAuth: String
    var SizeID: String
    init(
    DiscountPrice: String,
    IsPay: String,
    FServiceID: String,
    CategoryID: String,
    FServiceName: String,
    State: String,
    Price: String,
    SNeedPlatformAuth: String,
    SizeID: String) {
        self.DiscountPrice=DiscountPrice
        self.IsPay=IsPay
        self.FServiceID=FServiceID
        self.CategoryID=CategoryID
        self.FServiceName=FServiceName
        self.State=State
        self.Price=Price
        self.SNeedPlatformAuth=SNeedPlatformAuth
        self.SizeID=SizeID
    }
}
struct mLeavemessageList {
    var limit: Int = 0
    var factoryIslook: String?
    var Id: Int = 0
    var photo: String?
    var UserName: String?
    var IsUse: String?
    var UserId: String?
    var Content: String?
    var LeaveMessageId: Int = 0
    var platformIslook: String?
    var OrderId: Int = 0
    var workerIslook: String?
    var page: Int = 0
    var Version: Int = 0
    var CreateDate: String?
    var `Type`: String?

    init(json: JSON) {
        limit = json["limit"].intValue
        factoryIslook = json["factoryIslook"].stringValue
        Id = json["Id"].intValue
        photo = json["photo"].stringValue
        UserName = json["UserName"].stringValue
        IsUse = json["IsUse"].stringValue
        UserId = json["UserId"].stringValue
        Content = json["Content"].stringValue
        LeaveMessageId = json["LeaveMessageId"].intValue
        platformIslook = json["platformIslook"].stringValue
        OrderId = json["OrderId"].intValue
        workerIslook = json["workerIslook"].stringValue
        page = json["page"].intValue
        Version = json["Version"].intValue
        CreateDate = json["CreateDate"].stringValue
        Type = json["Type"].stringValue
    }
}
