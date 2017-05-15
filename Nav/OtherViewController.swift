//
//  OtherViewController.swift
//  Nav
//
//  Created by boitx on 2017/5/15.
//  Copyright © 2017年 boitx. All rights reserved.
//

import UIKit

// 遵守协议
class OtherViewController: UIViewController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftBtn = UIButton.init(type: UIButtonType.system)
        leftBtn.frame = CGRect(x:0 ,y:0, width:25, height:25)
        leftBtn.setBackgroundImage(UIImage.init(named: "nav_back"), for: UIControlState.normal)
        leftBtn.addTarget(self, action: #selector(leftBtnAction(btn:)), for: UIControlEvents.touchUpInside)
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        spaceItem.width = -15
        let leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        self.navigationItem.leftBarButtonItems = [spaceItem,leftBarButtonItem]
        
        // 设置代理
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;

    }
    
    func leftBtnAction(btn: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
