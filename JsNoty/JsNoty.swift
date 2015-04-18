//
//  GmJsNoty.swift
//  book-on.ios
//
//  Created by Masamoto Miyata on 2015/04/13.
//  Copyright (c) 2015年 Masamoto Miyata. All rights reserved.
//
import UIKit

protocol JsNotyDelegate{
    func didRecieveJsNotification(name:String, data:JSON?)
}

public class JsNoty:NSObject {
    private var webView:UIWebView;
    
    init(webView:UIWebView) {
        self.webView = webView;
    }
    
    var delegate:JsNotyDelegate?;
    
    public func receive(request:NSURLRequest) -> Bool{        
        if(request.URL!.scheme != "jsnoty"){
            return false;
        }
        
        self.webView.stringByEvaluatingJavaScriptFromString("document.dispatchEvent(new CustomEvent(\"JsNotyRecieved\"))");
        
        let key:String = request.URL!.host!;
        
        delegate?.didRecieveJsNotification(key, data: nil)
        
        return true;
    }
}