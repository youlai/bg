//
//  UIWebViewViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/2.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import WebKit

class UIWebViewViewController: UIViewController {
    @IBOutlet weak var webview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 下面一行代码意思是充满的意思(一定要加，不然也会显示有问题)
        webview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let mapwayURL = URL(string: "https://admin.xigyu.com")!
        let mapwayRequest = URLRequest(url: mapwayURL)
        webview.load(mapwayRequest)
    }
    @objc func close(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func back(){
        if webview.canGoBack{
            webview.goBack()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
}
