//
//  PageViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/20.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SnapKit
import Tabman
import Pageboy
class PageViewController: TabmanViewController,PageboyViewControllerDataSource, TMBarDataSource{
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
    
    var orderid:String!
    init(index:Int,orderid:String!){
        super.init(nibName: nil, bundle: nil)
        self.index=index
        self.orderid=orderid!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var vcs:[UIViewController]! = []
    var index:Int!
    let titles = ["订单详情","工单跟踪","支付记录", "配件信息", "服务信息"
        , "完结照片", "投诉信息", "留言信息"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vcs.append(OrderDetailViewController(orderid: orderid))
        vcs.append(OrderRecordTableViewController(orderid: orderid))
        vcs.append(OrderPayRecordTableViewController(orderid: orderid))
        vcs.append(OrderAccRecordTableViewController(orderid: orderid))
        vcs.append(OrderServiceRecordTableViewController(orderid: orderid))
        vcs.append(OrderReturnRecordTableViewController(orderid: orderid))
        vcs.append(OrderComplaintRecordTableViewController(orderid: orderid))
        vcs.append(LeaveMsgViewController(orderid: orderid))
        
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
        
        addBar(Tbar.systemBar(), dataSource: self, at: .top)
        self.view.backgroundColor=UIColor.white
        self.view.tintColor = .white
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
