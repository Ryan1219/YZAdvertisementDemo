//
//  ViewController.swift
//  YZAdvertisementDemo
//
//  Created by zhang liangwang on 16/6/22.
//  Copyright © 2016年 zhangliangwang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.title = "首页"
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.responseToAdver), name: NSNotification.Name(rawValue: "pushToAdver"), object: nil)
    }
    
    
    func responseToAdver() {
        
        let adverVC = YZAdverViewController()
        self.navigationController?.pushViewController(adverVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

