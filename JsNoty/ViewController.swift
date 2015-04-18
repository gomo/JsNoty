//
//  ViewController.swift
//  JsNoty
//
//  Created by Masamoto Miyata on 2015/04/18.
//  Copyright (c) 2015年 Masamoto Miyata. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate, JsNotyDelegate {
    
    private var webView:UIWebView!;
    private var jsNoty:JsNoty!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //画面いっぱいのWevView作成
        self.webView = UIWebView(frame: CGRectMake(
            0, 0,
            UIScreen.mainScreen().bounds.width,
            UIScreen.mainScreen().bounds.height
            ));
        self.view.addSubview(self.webView);
        self.webView.delegate = self;
        self.jsNoty = JsNoty(webView: self.webView);
        self.jsNoty.delegate = self;
        
        //webViewのキャッシュをクリア（開発用）
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        NSURLCache.sharedURLCache().diskCapacity = 0
        NSURLCache.sharedURLCache().memoryCapacity = 0
        
        let url = NSURL(string: "http://test.book-on.me/js/js-noty/test/index.html")
        let request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(self.jsNoty.receive(request)){
            return false;
        }
        
        return true
    }
    
    func didRecieveJsNotification(name:String, data:JSON?){
        println(name, data)
    }
    
    func webViewDidFinishLoad(webView: UIWebView){
        self.jsNoty.notify("firstFromSwift");
        self.jsNoty.notify("secondFromSwift", data: JSON(["foo": "bar"]));
    }
}

