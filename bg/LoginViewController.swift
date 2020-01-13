//
//  LoginViewController.swift
//  MasterWorker
//
//  Created by Apple on 2019/8/28.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var iv_img: UIImageView!
    @IBOutlet weak var uv_name: UIView!
    @IBOutlet weak var uv_pwd: UIView!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_pwd: UITextField!
    @IBOutlet weak var btn_codelogin: UIButton!
    @IBOutlet weak var btn_rigster: UIButton!
    @IBOutlet weak var btn_login: UIButton!
    var name:String!
    var pwd:String!

    override func awakeFromNib() {
        if UserID != nil && Pwd != nil && adminToken != nil {
            self.navigationController?.pushViewController(HomeViewController(), animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="登录"
        // Do any additional setup after loading the view.
        iv_img.layer.cornerRadius=40
        btn_login.layer.cornerRadius=5
        uv_name.border(color: .gray, width: 0.5, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 5)
        uv_pwd.border(color: .gray, width: 0.5, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 5)
//        btn_codelogin.addOnClickListener(target: self, action: #selector(codelogin))
        btn_login.addOnClickListener(target: self, action: #selector(login))
//        btn_rigster.addOnClickListener(target: self, action: #selector(register))
        tf_name.text=UserID
        tf_pwd.text=Pwd
    }
//    @objc func codelogin(){
//        self.navigationController?.pushViewController(CodeLoginViewController(), animated: true)
//    }
//    @objc func register(){
//        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
//    }
    @objc func login(){
        name=tf_name.text
        pwd=tf_pwd.text
        if name.isEmpty{
            HUD.showText("请输入手机号码")
            return
        }
        if pwd.isEmpty{
            HUD.showText("请输入密码")
            return
        }
        var d = ["userName":name,
                 "passWord":pwd,
                 "RoleType":"5"//角色类型 5平台 6工厂 7师傅 8商城 10代表包含5678
            ] as [String : String]
        AlamofireHelper.post(url: LoginOn, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                UserDefaults.standard.set(res["Data"]["Item2"].stringValue, forKey: "adminToken")
                UserDefaults.standard.set(ss.name, forKey: "UserID")
                UserDefaults.standard.set(ss.pwd, forKey: "Pwd")
                adminToken=UserDefaults.standard.string(forKey: "adminToken")
                UserID=UserDefaults.standard.string(forKey: "UserID")
                Pwd=UserDefaults.standard.string(forKey: "Pwd")
                HUD.showText("登录成功")
//                ss.addAndUpdatePushAccount()
                ss.navigationController?.pushViewController(HomeViewController(), animated: true)
            }else{
                HUD.showText(res["Data"]["Item2"].stringValue)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    @objc func addAndUpdatePushAccount(){
        let d = ["UserID":UserID,
                 "token":pushToken==nil ? "" : pushToken,
                 "type":"7",
                 "platform":"iOS"
            ] as! [String : String]
        AlamofireHelper.post(url: AddAndUpdatePushAccount, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }

}

