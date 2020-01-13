//
//  ViewController.swift
//  bg
//
//  Created by Apple on 2019/12/5.
//  Copyright © 2019 zhkj. All rights reserved.
//

import UIKit
class HomeViewController: UIViewController {

    //MARK: -厂商入驻待审核
    @IBOutlet weak var count1: UILabel!
    //MARK: -师傅入驻待审核
    @IBOutlet weak var count2: UILabel!
    //MARK: -已接单待服务
    @IBOutlet weak var count3: UILabel!
    //MARK: -远程费申请待审核
    @IBOutlet weak var count4: UILabel!
    //MARK: -今日入驻厂商
    @IBOutlet weak var count5: UILabel!
    //MARK: -昨日入驻厂商
    @IBOutlet weak var count6: UILabel!
    //MARK: -今日入驻师傅
    @IBOutlet weak var count7: UILabel!
    //MARK: -昨日入驻师傅
    @IBOutlet weak var count8: UILabel!
    //MARK: -工厂待处理仲裁
    @IBOutlet weak var count9: UILabel!
    //MARK: -师傅待处理仲裁
    @IBOutlet weak var count10: UILabel!
    //MARK: -待处理提现
    @IBOutlet weak var count0: UILabel!
    //MARK: -最新工单
    @IBOutlet weak var count11: UILabel!
    //MARK: -昨日工单
    @IBOutlet weak var count12: UILabel!
    //MARK: -质保工单
    @IBOutlet weak var count13: UILabel!
    //MARK: -远程费工单
    @IBOutlet weak var count14: UILabel!
    //MARK: -留言工单
    @IBOutlet weak var count15: UILabel!
    //MARK: -区域无师傅单
    @IBOutlet weak var count16: UILabel!
    //MARK: -完成工单
    @IBOutlet weak var count17: UILabel!
    //MARK: -已派未接单
    @IBOutlet weak var count18: UILabel!
    //MARK: -今日销售总额
    @IBOutlet weak var count19: UILabel!
    //MARK: -今日新增会员数
    @IBOutlet weak var count20: UILabel!
    //MARK: -平台总工单量
    @IBOutlet weak var count21: UILabel!
    //MARK: -配件工单
    @IBOutlet weak var count22: UILabel!
    //MARK:待完结工单
    @IBOutlet weak var count23: UILabel!
    @IBOutlet weak var uv_1: UIViewEffect!
    @IBOutlet weak var uv_2: UIViewEffect!
    @IBOutlet weak var uv_3: UIViewEffect!
    @IBOutlet weak var uv_4: UIViewEffect!
    @IBOutlet weak var uv_5: UIViewEffect!
    @IBOutlet weak var uv_6: UIViewEffect!
    @IBOutlet weak var uv_7: UIViewEffect!
    @IBOutlet weak var uv_8: UIViewEffect!
    @IBOutlet weak var uv_9: UIViewEffect!
    @IBOutlet weak var uv_11: UIViewEffect!
    @IBOutlet weak var uv_12: UIViewEffect!
    @IBOutlet weak var uv_13: UIViewEffect!
    @IBOutlet weak var uv_14: UIViewEffect!
    @IBOutlet weak var uv_15: UIViewEffect!
    @IBOutlet weak var uv_16: UIViewEffect!
    @IBOutlet weak var uv_17: UIViewEffect!
    @IBOutlet weak var uv_18: UIViewEffect!
    @IBOutlet weak var uv_19: UIViewEffect!
    @IBOutlet weak var uv_20: UIViewEffect!
    @IBOutlet weak var uv_21: UIViewEffect!
    @IBOutlet weak var uv_22: UIViewEffect!
    @IBOutlet weak var uv_23: UIViewEffect!
    @IBOutlet weak var uv_24: UIViewEffect!
    @IBOutlet weak var uv_25: UIViewEffect!
    @IBOutlet weak var usv: UIScrollView!
    var count=0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        salesToday()
        self.title="首页"
        uv_1.addOnClickListener(target: self, action: #selector(tolist1))
        uv_2.addOnClickListener(target: self, action: #selector(tolist2))
        uv_3.addOnClickListener(target: self, action: #selector(tolist3))
        uv_4.addOnClickListener(target: self, action: #selector(tolist4))
        uv_5.addOnClickListener(target: self, action: #selector(tolist5))
        uv_6.addOnClickListener(target: self, action: #selector(tolist6))
        uv_7.addOnClickListener(target: self, action: #selector(tolist7))
        uv_8.addOnClickListener(target: self, action: #selector(tolist8))
        uv_9.addOnClickListener(target: self, action: #selector(tolist9))
        uv_11.addOnClickListener(target: self, action: #selector(tolist11))
        uv_12.addOnClickListener(target: self, action: #selector(tolist12))
        uv_13.addOnClickListener(target: self, action: #selector(tolist13))
        uv_14.addOnClickListener(target: self, action: #selector(tolist14))
        uv_15.addOnClickListener(target: self, action: #selector(tolist15))
        uv_16.addOnClickListener(target: self, action: #selector(tolist16))
        uv_17.addOnClickListener(target: self, action: #selector(tolist17))
        uv_18.addOnClickListener(target: self, action: #selector(tolist18))
        uv_19.addOnClickListener(target: self, action: #selector(tolist19))
        uv_20.addOnClickListener(target: self, action: #selector(tolist20))
        uv_21.addOnClickListener(target: self, action: #selector(tolist21))
        uv_23.addOnClickListener(target: self, action: #selector(tolist22))
        uv_24.addOnClickListener(target: self, action: #selector(tolist23))
        uv_25.addOnClickListener(target: self, action: #selector(tolist25))
        refresh()
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.usv.mj_header?.endRefreshing()
            strongSelf.refresh()
        })
        
        usv.mj_header = header;
    }
    //MARK:
    @objc func refresh(){
//        HUD.show()
        salesToday()
    }
    //MARK:最新工单
    @objc func tolist1(){
        HUD.show()
        self.navigationController?.pushViewController(OrderTableViewController(status: 0), animated: true)
    }
    //MARK:昨日工单
    @objc func tolist2(){
        HUD.show()
        self.navigationController?.pushViewController(OrderTableViewController(status: 1), animated: true)
    }
    //MARK:质保工单
    @objc func tolist3(){
        HUD.show()
        self.navigationController?.pushViewController(OrderTableViewController(status: 2), animated: true)
    }
    //MARK:远程费工单
    @objc func tolist4(){
        HUD.show()
        self.navigationController?.pushViewController(OrderTableViewController(status: 3), animated: true)
    }
    //MARK:留言工单
    @objc func tolist5(){
        HUD.show()
        self.navigationController?.pushViewController(OrderTableViewController(status: 4), animated: true)
    }
    //MARK:区域无师傅
    @objc func tolist6(){
        HUD.show()
        self.navigationController?.pushViewController(OrderTableViewController(status: 5), animated: true)
    }
    //MARK:完成工单
    @objc func tolist7(){
        HUD.show()
        self.navigationController?.pushViewController(OrderTableViewController(status: 6), animated: true)
    }
    //MARK:已派未接单
    @objc func tolist8(){
        HUD.show()
        self.navigationController?.pushViewController(OrderTableViewController(status: 7), animated: true)
    }
    //MARK:配件工单
    @objc func tolist9(){
        HUD.show()
        self.navigationController?.pushViewController(OrderTableViewController(status: 8), animated: true)
    }
    //MARK:厂商入驻待审核
    @objc func tolist11(){
        HUD.show()
        self.navigationController?.pushViewController(SFTableViewController(orderid: "", type: "厂商入驻待审核"), animated: true)
    }
    //MARK:师傅入驻待审核
    @objc func tolist12(){
        HUD.show()
        self.navigationController?.pushViewController(SFTableViewController(orderid: "", type: "师傅入驻待审核"), animated: true)
    }
    //MARK:已接单待服务
    @objc func tolist13(){
        HUD.show()
        self.navigationController?.pushViewController(OrderTableViewController(status: 9), animated: true)
    }
    //MARK:远程费申请待审核
    @objc func tolist14(){
        HUD.show()
        self.navigationController?.pushViewController(OrderTableViewController(status: 10), animated: true)
    }
    //MARK:今日入驻厂商
    @objc func tolist15(){
        HUD.show()
        self.navigationController?.pushViewController(SFTableViewController(orderid: "", type: "今日入驻厂商"), animated: true)
    }
    //MARK:昨日入驻厂商
    @objc func tolist16(){
        HUD.show()
        self.navigationController?.pushViewController(SFTableViewController(orderid: "", type: "昨日入驻厂商"), animated: true)
    }
    //MARK:今日入驻师傅
    @objc func tolist17(){
        HUD.show()
        self.navigationController?.pushViewController(SFTableViewController(orderid: "", type: "今日入驻师傅"), animated: true)
    }
    //MARK:昨日入驻师傅
    @objc func tolist18(){
        HUD.show()
        self.navigationController?.pushViewController(SFTableViewController(orderid: "", type: "昨日入驻师傅"), animated: true)
    }
    //MARK:工厂待处理仲裁
    @objc func tolist19(){
        HUD.show()
        self.navigationController?.pushViewController(OrderTableViewController(status: 11), animated: true)
    }
    //MARK:师傅待处理仲裁
    @objc func tolist20(){
        HUD.show()
        self.navigationController?.pushViewController(OrderTableViewController(status: 12), animated: true)
    }
    //MARK:待处理提现
    @objc func tolist21(){
        HUD.show()
        self.navigationController?.pushViewController(WithDrawTableViewController(), animated: true)
    }
    //MARK:今日新增会员数
    @objc func tolist22(){
        HUD.show()
        self.navigationController?.pushViewController(SFTableViewController(orderid: "", type: "今日新增会员数"), animated: true)
    }
    //MARK:平台所有工单
    @objc func tolist23(){
        HUD.show()
        self.navigationController?.pushViewController(OrderTableViewController(status: 13), animated: true)
    }
    //MARK:待完结工单
    @objc func tolist25(){
        HUD.show()
        self.navigationController?.pushViewController(OrderTableViewController(status: 14), animated: true)
    }
    @objc func salesToday(){
        AlamofireHelper.post(url: SalesToday, parameters: nil, successHandler: {[weak self](res)in
            guard let ss = self else {return}
            //      "orderCount" : 867,
            //      "money" : 329,
            //      "Count" : 6
            ss.count19.text=res["Data"]["Item2"]["money"].stringValue
            ss.count20.text=res["Data"]["Item2"]["Count"].stringValue
            ss.count21.text=res["Data"]["Item2"]["orderCount"].stringValue
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
            ss.count1.text=res["Data"]["Item2"]["factoryExamineCount"].stringValue
            ss.count2.text=res["Data"]["Item2"]["MasterWorkerCount"].stringValue
            ss.count3.text=res["Data"]["Item2"]["InServiceOreder"].stringValue
            ss.count4.text=res["Data"]["Item2"]["LongRange"].stringValue
            ss.count5.text=res["Data"]["Item2"]["TodayFactoryCount"].stringValue
            ss.count6.text=res["Data"]["Item2"]["YesterdayFactoryCount"].stringValue
            ss.count7.text=res["Data"]["Item2"]["TodayMasterWorkerCount"].stringValue
            ss.count8.text=res["Data"]["Item2"]["YesterdayMasterWorkerCount"].stringValue
            ss.count9.text=res["Data"]["Item2"]["factorycomplaint"].stringValue
            ss.count10.text=res["Data"]["Item2"]["ComplaintCount"].stringValue
            ss.count0.text=res["Data"]["Item2"]["withdrawalCount"].stringValue
            ss.salesToday3()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
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
            ss.count11.text=res["Data"]["Item2"]["newOrder"].stringValue
            ss.count12.text=res["Data"]["Item2"]["YesterdayOrder"].stringValue
            ss.count13.text=res["Data"]["Item2"]["QualityAssurance"].stringValue
            ss.count14.text=res["Data"]["Item2"]["serviceCount"].stringValue
            ss.count15.text=res["Data"]["Item2"]["LeavemessageServiceCount"].stringValue
            ss.count16.text=res["Data"]["Item2"]["ComplaintCount2"].stringValue
            ss.count17.text=res["Data"]["Item2"]["completeCount"].stringValue
            ss.count18.text=res["Data"]["Item2"]["AbolishCount"].stringValue
            ss.count22.text=res["Data"]["Item2"]["OrderAccessroyDetailCount"].stringValue
            ss.count23.text=res["Data"]["Item2"]["TobePaid"].stringValue
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}

//{
//  "Data" : {
//    "Item2" : "fecb6080-3761-4161-a0cd-8f6f03dbd5d1",
//    "Item1" : true
//  },
//  "StatusCode" : 200,
//  "Info" : "请求(或处理)成功"
//}
//{
//  "StatusCode" : 200,
//  "Info" : "请求(或处理)成功",
//  "Data" : "用户名为空"
//}
//{
//  "Data" : {
//    "Item2" : {
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
//    },
//    "Item1" : true
//  },
//  "StatusCode" : 200,
//  "Info" : "请求(或处理)成功"
//}
//{
//  "StatusCode" : 200,
//  "Info" : "请求(或处理)成功",
//  "Data" : {
//    "Item1" : true,
//    "Item2" : {
//      "orderCount" : 867,
//      "money" : 329,
//      "Count" : 6
//    }
//  }
//}
//{
//  "StatusCode" : 200,
//  "Data" : {
//    "Item2" : {
//      "newOrder" : 13,
//      "LeavemessageServiceCount" : 152,
//      "completeCount" : 385,
//      "serviceCount" : 6,
//      "QualityAssurance" : 15,
//      "AbolishCount" : 60,
//      "OrderAccessroyDetailCount" : 292,
//      "ComplaintCount2" : 2
//    },
//    "Item1" : true
//  },
//  "Info" : "请求(或处理)成功"
//}
