//
//  OrderComplaintRecordTableViewController.swift
//  bg
//
//  Created by Apple on 2019/12/31.
//  Copyright © 2019 zhkj. All rights reserved.
//

import UIKit
import SwiftyJSON
import SKPhotoBrowser

class OrderComplaintRecordTableViewController: UITableViewController {
    var dataSource=[mComplaintBean]()
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

        getComplaintListByOrderId()
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.getComplaintListByOrderId()
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
        let cell=tableView.dequeueReusableCell(withIdentifier: "re")as! XgyOrderRecordTableViewCell
        let item=dataSource[indexPath.row]
        cell.lb_time.text="(\(item.UserID!)投诉\(item.ComplaintUser!))\(item.CreateTime!.replacingOccurrences(of: "T", with: " "))"
        cell.lb_content.text=item.Content
        cell.selectionStyle = .none
        return cell
    }
    //MARK:查看大图
//    @objc func biger(){
//        // URL pattern snippet
//        var images = [SKPhoto]()
//        for item in dataSource {
//            images.append(SKPhoto.photoWithImageURL("https://img.xigyu.com/Pics/OldAccessory/\(item.Url!)"))
//        }
//        
//        // create PhotoBrowser Instance, and present.
//        let browser = SKPhotoBrowser(photos: images)
//        self.present(browser, animated: true, completion: {})
//    }
    //MARK:获取工单详情
    @objc func getComplaintListByOrderId(){
        let d = ["OrderId":orderid!,
                 "UserID":""
        ]
        print(d)
        AlamofireHelper.post(url: GetComplaintListByOrderId, parameters: d , successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.dataSource=res["Data"].arrayValue.compactMap({mComplaintBean(json: $0)})
            ss.tableView.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
struct mComplaintBean {
    var ComplaintType: String?
    var limit: Int = 0
    var Order: String?
    var Photo: String?
    var `Type`: String?
    var OrderID: Int = 0
    var Content: String?
    var page: Int = 0
    var ComplaintUser: String?
    var UserID: String?
    var ComplaintID: Int = 0
    var CreateTime: String?
    var Version: Int = 0
    var Id: Int = 0
    var IsUse: String?

    init(json: JSON) {
        ComplaintType = json["ComplaintType"].stringValue
        limit = json["limit"].intValue
        Order = json["Order"].stringValue
        Photo = json["Photo"].stringValue
        Type = json["Type"].stringValue
        OrderID = json["OrderID"].intValue
        Content = json["Content"].stringValue
        page = json["page"].intValue
        ComplaintUser = json["ComplaintUser"].stringValue
        UserID = json["UserID"].stringValue
        ComplaintID = json["ComplaintID"].intValue
        CreateTime = json["CreateTime"].stringValue
        Version = json["Version"].intValue
        Id = json["Id"].intValue
        IsUse = json["IsUse"].stringValue
    }
}
