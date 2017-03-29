//
//  YZAdverViewController.swift
//  YZAdvertisementDemo
//
//  Created by zhangliangwang on 16/6/22.
//  Copyright © 2016年 zhangliangwang. All rights reserved.
//

import UIKit

class YZAdverViewController: UIViewController ,UIWebViewDelegate {
    
    var webView: UIWebView?
    var activity: UIActivityIndicatorView?
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.webView?.delegate = nil
        self.webView?.stopLoading()
        self.webView?.removeFromSuperview()
        self.webView = nil
        
        self.activity?.removeFromSuperview()
        self.activity = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "加油"
        
        self.webView = UIWebView.init(frame: self.view.bounds)
        self.webView?.backgroundColor = UIColor(white: 229/255.0, alpha: 1.0)
        self.webView?.isOpaque = false
        self.webView?.autoresizingMask = [.flexibleTopMargin,.flexibleLeftMargin,.flexibleBottomMargin,.flexibleRightMargin,.flexibleWidth,.flexibleHeight]
        self.webView?.delegate = self
        self.view.addSubview(self.webView!)
        
        
        self.activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.activity?.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        self.activity?.startAnimating()
        
        
        let url = URL(string: "http://www.baidu.com")
        let request = NSMutableURLRequest(url: url!)
        self.webView?.loadRequest(request as URLRequest)
        
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.activity?.stopAnimating()
        self.activity?.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
}

















































































































