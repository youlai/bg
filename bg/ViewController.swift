//
//  ViewController.swift
//  bg
//
//  Created by Apple on 2019/12/5.
//  Copyright © 2019 zhkj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        salesToday()
        salesToday2()
        salesToday3()
    }
    @objc func salesToday(){
        AlamofireHelper.post(url: SalesToday, parameters: nil, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    @objc func salesToday2(){
        AlamofireHelper.post(url: SalesToday2, parameters: nil, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    @objc func salesToday3(){
        AlamofireHelper.post(url: SalesToday3, parameters: nil, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}

