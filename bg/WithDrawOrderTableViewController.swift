//
//  WithDrawOrderTableViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/26.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import EventKit
import MapKit

class WithDrawOrderTableViewController: UITableViewController,EmptyViewProtocol,UISearchBarDelegate {
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
    var senduser:String!
    var pageNo:Int=1
    var limit:Int=10
    var dataSouce=[mOrder]()
    var orders=[mOrder]()
    var order:mOrder!
    var jsonStr:JSON!
    var startDate:Date!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        initSearchBar()
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
            strongSelf.loadData()
        })
        
        tableView.mj_header = header;
        
        let footer = TTRefreshFooter  {  [weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNo = strongSelf.pageNo + 1
            strongSelf.loadData()
        }
        
        tableView.mj_footer = footer
        tableView.mj_footer!.isHidden = false
    }
    init(user:String,name:String){
        super.init(style: UITableView.Style.plain)
        self.senduser=user
        self.title="师傅\(name)处理的工单"
        loadData()
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
        loadData()
    }
    //MARK:最新工单
    @objc func loadData(){
        //        "UserID":"",
        //        "State":"",
        //        "OrderID":"",
        //        "TypeID":"",
        //        "CreateDate":"",
        //        "partsIs":"",
        //        "messageIs":"",
        
        var d = [
            
            "page":"\(pageNo)",
            "limit":"\(limit)",
            "SendUser":senduser!
            
            ] as [String:Any]
        if keyword != nil {
            d["OrderID"]=keyword
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
