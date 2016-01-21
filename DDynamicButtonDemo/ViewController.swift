//
//  ViewController.swift
//  DDynamicButtonDemo
//
//  Created by 端 闻 on 21/11/14.
//  Copyright (c) 2014年 monk-studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bigShow()

    }
    func bigShow(){
        let btn = DDynamicMenuButton(frame: CGRectMake(10, 60, 50, 50))
        self.view.addSubview(btn)
        let btn2 = DDynamicArrowButton(frame:CGRectMake(10, 110, 50, 50))
        self.view.addSubview(btn2)
        let btn3 = DDynamicArrowButton(frame: CGRectMake(60, 110, 50, 50))
        btn3.direction = arrowDirection.up
        self.view.addSubview(btn3)
        let btn4 = DDynamicArrowButton(frame: CGRectMake(110, 110, 50, 50))
        btn4.direction = arrowDirection.right
        self.view.addSubview(btn4)
        let btn5 = DDynamicArrowButton(frame: CGRectMake(160, 110, 50, 50))
        btn5.direction = arrowDirection.down
        self.view.addSubview(btn5)
        let btn6 = DDynamicArrowButton(frame: CGRectMake(10, 160, 50, 50))
        btn6.direction = arrowDirection.leftUp
        self.view.addSubview(btn6)
        let btn7 = DDynamicArrowButton(frame: CGRectMake(60, 160, 50, 50))
        btn7.direction = arrowDirection.rightUp
        self.view.addSubview(btn7)
        let btn8 = DDynamicArrowButton(frame: CGRectMake(10, 210, 50, 50))
        btn8.direction = arrowDirection.leftDown
        self.view.addSubview(btn8)
        let btn9 = DDynamicArrowButton(frame: CGRectMake(60, 210, 50, 50))
        btn9.direction = arrowDirection.rightDown
        self.view.addSubview(btn9)
        let btn10 = DDynamicShareButton(frame:CGRectMake(60, 60, 50, 50))
        self.view.addSubview(btn10)
        let btn11 = DDynamicWriteButton(frame:CGRectMake(110, 60, 50, 50))
        self.view.addSubview(btn11)
        let btn12 = DDynamicTextButton(frame:CGRectMake(10, 260, 60, 50))
        self.view.addSubview(btn12)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

