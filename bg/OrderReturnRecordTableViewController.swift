//
//  OrderReturnRecordTableViewController.swift
//  bg
//
//  Created by Apple on 2019/12/31.
//  Copyright © 2019 zhkj. All rights reserved.
//

import UIKit
import SwiftyJSON
import SKPhotoBrowser

class OrderReturnRecordTableViewController: UITableViewController {
    var dataSource=[mReturnaccessoryImg]()
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
        tableView.register(UINib(nibName: "ReturnTableViewCell", bundle: nil), forCellReuseIdentifier: "re")

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
        return dataSource.count>0 ? 1 :0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "re")as! ReturnTableViewCell
        if dataSource.count==1 {
            cell.iv_photo1.setImage(path: URL(string: "https://img.xigyu.com/Pics/OldAccessory/\(dataSource[0].Url ?? "")")!)

        }
        if dataSource.count==2 {
            cell.iv_photo1.setImage(path: URL(string: "https://img.xigyu.com/Pics/OldAccessory/\(dataSource[0].Url ?? "")")!)
            cell.iv_photo2.setImage(path: URL(string: "https://img.xigyu.com/Pics/OldAccessory/\(dataSource[1].Url ?? "")")!)

        }
        if dataSource.count==3 {
            cell.iv_photo1.setImage(path: URL(string: "https://img.xigyu.com/Pics/OldAccessory/\(dataSource[0].Url ?? "")")!)
            cell.iv_photo2.setImage(path: URL(string: "https://img.xigyu.com/Pics/OldAccessory/\(dataSource[1].Url ?? "")")!)
            cell.iv_photo3.setImage(path: URL(string: "https://img.xigyu.com/Pics/OldAccessory/\(dataSource[2].Url ?? "")")!)

        }
        if dataSource.count==4 {
            cell.iv_photo1.setImage(path: URL(string: "https://img.xigyu.com/Pics/OldAccessory/\(dataSource[0].Url ?? "")")!)
            cell.iv_photo2.setImage(path: URL(string: "https://img.xigyu.com/Pics/OldAccessory/\(dataSource[1].Url ?? "")")!)
            cell.iv_photo3.setImage(path: URL(string: "https://img.xigyu.com/Pics/OldAccessory/\(dataSource[2].Url ?? "")")!)
            cell.iv_photo4.setImage(path: URL(string: "https://img.xigyu.com/Pics/OldAccessory/\(dataSource[3].Url ?? "")")!)

        }
        cell.iv_photo1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(biger)))
        cell.iv_photo2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(biger)))
        cell.iv_photo3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(biger)))
        cell.iv_photo4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(biger)))

        cell.selectionStyle = .none
        return cell
    }
    //MARK:查看大图
    @objc func biger(){
        // URL pattern snippet
        var images = [SKPhoto]()
        for item in dataSource {
            images.append(SKPhoto.photoWithImageURL("https://img.xigyu.com/Pics/OldAccessory/\(item.Url!)"))
        }
        
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
            ss.dataSource=ss.detail.Data!.ReturnaccessoryImg
            ss.tableView.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
