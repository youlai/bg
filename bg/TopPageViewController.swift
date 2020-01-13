//
//  TopPageViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/20.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SnapKit
import Tabman
import Pageboy
class TopPageViewController: TabmanViewController,PageboyViewControllerDataSource, TMBarDataSource{
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return vcs.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return vcs[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.at(index: self.index)
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: titles[index])
    }
    
    
    init(index:Int){
        super.init(nibName: nil, bundle: nil)
        self.index=index
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var vcs:[UIViewController]! = []
    var index:Int!
    let titles = ["厂商入驻待审核","师傅入驻待审核", "已接单待服务", "远程费申请待审核"
        , "今日入驻厂商", "昨日入驻厂商", "今日入驻师傅",
          "昨日入驻师傅",
          "工厂待处理仲裁",
          "师傅待处理仲裁",
          "待处理提现"]
    let statuses = [0,1,2,3,4,5,6,7,8,9,10]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in statuses{
            vcs.append(SFTableViewController(orderid: "", type: ""))
        }
        self.dataSource = self
        
        // Create bar
        let Tbar = TMBar.ButtonBar()
        
        Tbar.layout.transitionStyle = .none // Customize
        Tbar.buttons.customize { (button) in
            button.tintColor = .black
            button.selectedTintColor = "#048CFF".color()
            button.font=UIFont.systemFont(ofSize: 16)
        }
        Tbar.indicator.tintColor = "#048CFF".color()
        Tbar.indicator.weight = .custom(value: 1)
        Tbar.layout.contentMode = .intrinsic
        Tbar.tintColor = .white
        Tbar.backgroundColor = .white
        Tbar.snp.makeConstraints { (make) in
            make.height.equalTo(60)
        }
        Tbar.layout.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        
        addBar(Tbar, dataSource: self, at: .top)
        self.view.backgroundColor=UIColor.white
        self.view.tintColor = .white
        //MARK:接收通知
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("预约成功"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("预约不成功"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("已完成"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("待返件"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("待审核"), object: nil)
    }
    //MARK:接收通知刷新接单列表
    @objc func reload(noti:Notification){
        if noti.name.rawValue=="预约成功"{
            self.index=2
        }else if noti.name.rawValue=="预约不成功"{
            self.index=8
        }else if noti.name.rawValue=="已完成"{
            self.index=7
        }else if noti.name.rawValue=="待返件"{
            self.index=4
        }else if noti.name.rawValue=="待审核"{
            self.index=3
        }
        
        vcs.removeAll()
        for index in statuses{
            vcs.append(OrderTableViewController(status: index))
        }
        self.reloadData()
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
