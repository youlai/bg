//
//  UIViewEffect.swift
//  bg
//
//  Created by Apple on 2020/1/6.
//  Copyright © 2020 zhkj. All rights reserved.
//
import UIKit

class UIViewEffect : UIView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundColor = UIColor.groupTableViewBackground
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.01) {
            self.backgroundColor = UIColor.clear
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.01) {
            self.backgroundColor = UIColor.clear
        }
    }
}
