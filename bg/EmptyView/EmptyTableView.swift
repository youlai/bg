//
//  EmptyTableView.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/29.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit

private let EmptyViewTag = 12345;

protocol EmptyViewProtocol: NSObjectProtocol {
    
    ///用以判断是会否显示空视图
    var showEmtpy: Bool {get}
    
    ///配置空数据提示图用于展示
    func configEmptyView() -> UIView?
}

extension EmptyViewProtocol {
    
    func configEmptyView() -> UIView? {
        return nil
    }
}
extension UITableView{
    
    
    func setEmtpyViewDelegate(target: EmptyViewProtocol) {
        self.emptyDelegate = target
        DispatchQueue.once(#function) {
            Tools.exchangeMethod(cls: self.classForCoder, targetSel: #selector(self.layoutSubviews), newSel: #selector(self.re_layoutSubviews))
        }
    }
    
    @objc func re_layoutSubviews() {
        self.re_layoutSubviews()
        if (self.emptyDelegate != nil){
            if self.emptyDelegate!.showEmtpy {
                
                guard let view = self.emptyDelegate?.configEmptyView() else {
                    return;
                }
                
                if let subView = self.viewWithTag(EmptyViewTag) {
                    subView.removeFromSuperview()
                }
                
                view.tag = EmptyViewTag;
                self.addSubview(view)
            } else {
                
                guard let view = self.viewWithTag(EmptyViewTag) else {
                    return;
                }
                view .removeFromSuperview()
            }
        }
        
    }
    
    //MARK:- ***** Associated Object *****
    private struct AssociatedKeys {
        static var emptyViewDelegate = "tableView_emptyViewDelegate"
    }
    
    private var emptyDelegate: EmptyViewProtocol? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.emptyViewDelegate)==nil ? nil : (objc_getAssociatedObject(self, &AssociatedKeys.emptyViewDelegate) as! EmptyViewProtocol)
        }
        set (newValue){
            objc_setAssociatedObject(self, &AssociatedKeys.emptyViewDelegate, newValue!, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
