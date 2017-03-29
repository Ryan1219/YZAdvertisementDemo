//
//  YZLaunchAdverView.swift
//  YZAdvertisementDemo
//
//  Created by zhang liangwang on 16/6/22.
//  Copyright © 2016年 zhangliangwang. All rights reserved.
//

import UIKit


//MARK:- 屏幕高度 & 屏幕宽度
let ScreenHeight = UIScreen.main.bounds.size.height
let ScreenWidth = UIScreen.main.bounds.size.width
let kImageName = "kImageName"


//显示全屏还是不全屏
enum AdvertiseType: Int {
    case advertiseType_Full
    case advertiseType_Logo
}


class YZLaunchAdverView: UIView {
    
    var didClickBlock:((NSInteger) -> Void)!
    var adverImageView: UIImageView!
    var timeCount: Int!
    var adverType:AdvertiseType = .advertiseType_Full
    var timer: Timer!
    var skipBtn: UIButton!
    var isClick: String?
    var secondsCountDown: Int!
    var filePath: String?
    
    var showTime: Int = 3
    
    
    init(frame: CGRect,type:AdvertiseType,imageUrl: String) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        self.buileUI(type, imageUrl: imageUrl)
        
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //显示广告页
    func show() {
        self.setupTimer()
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    
    //启动定时器
    fileprivate func setupTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(YZLaunchAdverView.countDown), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer, forMode: RunLoopMode.commonModes)
    }

    //创建界面
    fileprivate func buileUI(_ type:AdvertiseType,imageUrl:String) {
        
        //广告图片
        let adverImageView = UIImageView.init()
        switch type {
        case .advertiseType_Full:
            adverImageView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        case .advertiseType_Logo:
            adverImageView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - ScreenWidth / 3)
        }
        adverImageView.isUserInteractionEnabled = true
        adverImageView.image = UIImage(contentsOfFile: imageUrl)
        self.addSubview(adverImageView)
        self.adverImageView = adverImageView
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(YZLaunchAdverView.pushToAdver))
        self.adverImageView.addGestureRecognizer(tap)
        
        //跳过按钮
        let btnW: CGFloat = 60
        let btnH: CGFloat = 30
        let skipBtn = UIButton.init(frame: CGRect(x: ScreenWidth - btnW - 24, y: btnH, width: btnW, height: btnH))
        skipBtn.backgroundColor = UIColor.brown
        skipBtn.setTitle("跳过\(showTime)", for: UIControlState())
        skipBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        skipBtn.addTarget(self, action: #selector(YZLaunchAdverView.clickSkipBtn), for: .touchUpInside)
        skipBtn.layer.cornerRadius = 4
        self.addSubview(skipBtn)
        self.skipBtn = skipBtn
        
        
    }
    
    //响应手势
    func pushToAdver() {
        self.clickSkipBtn()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "pushToAdver"), object: nil)
    }
    
    //定时器倒计时
    func countDown() {
        
        showTime -= 1
        self.skipBtn.setTitle("跳过\(showTime)", for: UIControlState())
        if showTime == 0 {
            self.clickSkipBtn()
        }
    }
    
    //点击跳过按钮
    func clickSkipBtn() {
        self.timer.invalidate()
        self.timer = nil
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            self.alpha = 0
            }, completion: { (finished) -> Void in
                self.removeFromSuperview()
        }) 
    }

    
    
}












































































