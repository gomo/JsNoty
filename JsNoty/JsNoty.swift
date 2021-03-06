//
//  JsNoty.swift
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
    
    public func recieve(request:NSURLRequest) -> Bool{
        if(request.URL!.scheme != "jsnoty"){
            return false;
        }
        
        self.notify("JsNotyRecieved");
        
        let paths = split(request.URL!.path!){$0 == "/"};
        var data:JSON? = nil;
        if(!paths.isEmpty){
            data = JSON(paths[0]);
        }
        
        let key:String = request.URL!.host!;
        
        delegate?.didRecieveJsNotification(key, data: data)
        
        return true;
    }
    
    public func notify(name:String){
        self.notify(name, data: nil);
    }
    
    public func notify(name:String, data:JSON?){
        var script:String;
        if(data != nil){
            script = String(format: "$(document).trigger(\"%@\", %@)", name, data!.toString());
        } else {
            script = String(format: "$(document).trigger(\"%@\")", name);
        }
        
        self.webView.stringByEvaluatingJavaScriptFromString(script);
    }
}