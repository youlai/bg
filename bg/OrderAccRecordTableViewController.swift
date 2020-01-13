//
//  OrderAccRecordTableViewController.swift
//  bg
//
//  Created by Apple on 2019/12/31.
//  Copyright © 2019 zhkj. All rights reserved.
//

import UIKit
import SwiftyJSON
import SKPhotoBrowser

class OrderAccRecordTableViewController: UITableViewController {
    var dataSource=[mOrderAccessroyDetail]()
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
        tableView.register(UINib(nibName: "AccTableViewCell", bundle: nil), forCellReuseIdentifier: "re")
        tableView.separatorStyle = .none
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
        let cell=tableView.dequeueReusableCell(withIdentifier: "re") as! AccTableViewCell
        let item=dataSource[indexPath.row]
        cell.lb_name.text=item.FAccessoryName
        cell.iv_photo1.setImage(path: URL(string: "https://img.xigyu.com/Pics/Accessory/\(item.Photo1 ?? "")")!)
        cell.iv_photo2.setImage(path: URL(string: "https://img.xigyu.com/Pics/Accessory/\(item.Photo2 ?? "")")!)
        let tap1=UITapGestureRecognizer(target: self, action: #selector(biger(ges:)))
        cell.iv_photo1.addGestureRecognizer(tap1)
        tap1.view!.tag=indexPath.row
        let tap2=UITapGestureRecognizer(target: self, action: #selector(biger(ges:)))
        cell.iv_photo2.addGestureRecognizer(tap2)
        tap2.view!.tag=indexPath.row
        cell.selectionStyle = .none
        return cell
    }
    //MARK:查看大图
    @objc func biger(ges:UITapGestureRecognizer){
        let item=dataSource[ges.view!.tag]
        // URL pattern snippet
        var images = [SKPhoto]()
        images.append(SKPhoto.photoWithImageURL("https://img.xigyu.com/Pics/Accessory/\(item.Photo1 ?? "")"))
        images.append(SKPhoto.photoWithImageURL("https://img.xigyu.com/Pics/Accessory/\(item.Photo2 ?? "")"))
        
        // create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        self.present(browser, animated: true, completion: {})
    }
    //MARK:获取工单详情
    @objc func getOrderInfo(){
        let d = ["OrderID":orderid!]
        AlamofireHelper.post(url: GetOrderInfo, parameters: d , successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.detail=mOrderDetail.init(json: res)
            ss.dataSource=ss.detail.Data!.OrderAccessroyDetail
            ss.tableView.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
