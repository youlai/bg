//
//  PersonalInfoTableViewController.swift
//  bg
//
//  Created by Apple on 2019/12/31.
//  Copyright © 2019 zhkj. All rights reserved.
//

import UIKit
import SwiftyJSON
import SKPhotoBrowser

class PersonalInfoTableViewController: UITableViewController {
    var dataSource=[(String,String)]()
    var userid:String!
    var State:String!
    var AuthMessage:String!
    var templist=[mSF]()
    var imglist=[mCardIMG]()
    init(userid:String){
        super.init(nibName: nil, bundle: nil)
        self.userid=userid
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="个人信息"
        tableView.register(UINib(nibName: "IDCardImgTableViewCell", bundle: nil), forCellReuseIdentifier: "idcard")
        
        getUserInfoList()
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.tableView.mj_header!.endRefreshing()
            strongSelf.getUserInfoList()
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
        return dataSource.count+1
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row<dataSource.count{
            var cell=tableView.dequeueReusableCell(withIdentifier: "re")
            if cell==nil{
                cell=UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "reuse")
            }
            cell?.textLabel?.text=dataSource[indexPath.row].0
            cell?.detailTextLabel?.text=dataSource[indexPath.row].1
            cell?.selectionStyle = .none
            return cell!
        }else{
            let cell=tableView.dequeueReusableCell(withIdentifier: "idcard") as! IDCardImgTableViewCell
            if imglist.count==3{
                cell.pic_1.setImage(path: URL(string: "https://img.xigyu.com/Pics/IDCard/\(imglist[0].ImageUrl ?? "")")!)
                cell.pic_2.setImage(path: URL(string: "https://img.xigyu.com/Pics/IDCard/\(imglist[1].ImageUrl ?? "")")!)
                cell.pic_3.setImage(path: URL(string: "https://img.xigyu.com/Pics/IDCard/\(imglist[2].ImageUrl ?? "")")!)
                cell.pic_1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(biger)))
                cell.pic_2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(biger)))
                cell.pic_3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(biger)))
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    //MARK:查看大图
    @objc func biger(){
        // URL pattern snippet
        var images = [SKPhoto]()
        for item in imglist {
            images.append(SKPhoto.photoWithImageURL("https://img.xigyu.com/Pics/IDCard/\(item.ImageUrl!)"))
        }
        
        // create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        self.present(browser, animated: true, completion: {})
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    // MARK: - 获取账号列表
    @objc func getUserInfoList(){
        var d = ["limit":"1",
            "UserID":userid!
        ]
        print(d)
        AlamofireHelper.post(url: GetUserInfoList, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["StatusCode"].intValue==200{
                ss.dataSource.removeAll()
                
            ss.templist=res["Data"]["data"].arrayValue.compactMap({ mSF(json: $0)})
                ss.dataSource.append(("账号类型",ss.templist[0].TypeStr!))
                ss.dataSource.append(("注册时间",ss.templist[0].CreateDate!))
                ss.dataSource.append(("最近登录时间",ss.templist[0].LastLoginDate!))
                ss.dataSource.append(("真实姓名",ss.templist[0].TrueName!))
                ss.dataSource.append(("昵称",ss.templist[0].NickName!))
                ss.dataSource.append(("手机号码",ss.templist[0].Phone!))
                ss.dataSource.append(("性别",ss.templist[0].Sex!))
                ss.dataSource.append(("地址",ss.templist[0].Address!))
                ss.dataSource.append(("身份证号码",ss.templist[0].IDCard!))
                ss.dataSource.append(("是否实名",ss.templist[0].IfAuthStr!))
                if ss.templist[0].IfAuth=="0"{
                    ss.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "审核", style: UIBarButtonItem.Style.done, target: self, action: #selector(ss.approveAuthPop))
                }else{
                    ss.navigationItem.rightBarButtonItem=nil
                }
                ss.dataSource.append(("余额","\(ss.templist[0].TotalMoney)"))
                ss.dataSource.append(("冻结金额","\(ss.templist[0].FrozenMoney)"))
                ss.dataSource.append(("保证金","\(ss.templist[0].DepositMoney)"))
                ss.dataSource.append(("服务赚取总金额","\(ss.templist[0].ServiceTotalMoney)"))
                ss.dataSource.append(("被投诉单量","\(ss.templist[0].ServiceComplaintNum)"))
                ss.dataSource.append(("完成单量","\(ss.templist[0].ServiceTotalOrderNum)"))
                ss.getIDCardImg()
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:审核账号
    @objc func approveAuthPop(){
        let alertController = UIAlertController(title: "审核账号", message: "是否通过", preferredStyle: UIAlertController.Style.alert);
        alertController.addTextField { (textField:UITextField!) -> Void in
            textField.placeholder = "如果拒绝填写原因，通过可不填";
        }
        let cancelAction = UIAlertAction(title: "拒绝", style: UIAlertAction.Style.destructive){ (ACTION) -> Void in
            let tf_AuthMessage = alertController.textFields!.first! as UITextField
            print("理由：\(tf_AuthMessage.text!)")
            self.AuthMessage=tf_AuthMessage.text!
            if self.AuthMessage.isEmpty{
                HUD.showText("请填写拒绝理由！")
//                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.State="-1"
            self.approveAuth()
        }
        let okAction = UIAlertAction(title: "通过", style: UIAlertAction.Style.default) { (ACTION) -> Void in
            let tf_AuthMessage = alertController.textFields!.first! as UITextField
            print("理由：\(tf_AuthMessage.text!)")
            self.AuthMessage=tf_AuthMessage.text!
            self.State="1"
            self.approveAuth()
        }
        let dismissAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.default,handler: nil)
        alertController.addAction(cancelAction);
        alertController.addAction(okAction);
        alertController.addAction(dismissAction);
        self.present(alertController, animated: true, completion: nil)
    }
    @objc func approveAuth(){
        let d = ["UserID":userid,
                 "State":State,
            "AuthMessage":AuthMessage
            ] as! [String : String]
        AlamofireHelper.post(url: ApproveAuth, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                HUD.showText("操作成功！")
                ss.getUserInfoList()
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK: - 获取用户实名照片
    @objc func getIDCardImg(){
        let d = ["UserID":userid] as! [String : String]
        AlamofireHelper.post(url: GetIDCardImg, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.imglist=res["Data"].arrayValue.compactMap({ mCardIMG(json: $0)})
            ss.tableView.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
struct mCardIMG {
    var Version: Int = 0
    var IsUse: String?
    var page: Int = 0
    var UserID: String?
    var ImageUrl: String?
    var AccountIDCardPicID: Int = 0
    var limit: Int = 0
    var Sort: String?
    var Id: Int = 0

    init(json: JSON) {
        Version = json["Version"].intValue
        IsUse = json["IsUse"].stringValue
        page = json["page"].intValue
        UserID = json["UserID"].stringValue
        ImageUrl = json["ImageUrl"].stringValue
        AccountIDCardPicID = json["AccountIDCardPicID"].intValue
        limit = json["limit"].intValue
        Sort = json["Sort"].stringValue
        Id = json["Id"].intValue
    }
}
