# JsNoty

This is a module that communicates javascript and Swift on the UIWebView.

## Usage

### Dependency

Needs [swift-json](https://github.com/dankogai/swift-json)

### Install

Add [JsNoty.swift](https://github.com/gomo/JsNoty/blob/master/JsNoty/JsNoty.swift) to your project, and load [JsNoty.js](https://github.com/gomo/JsNoty/blob/master/JsNoty/js/JsNoty.js) to you web page.

## Swift side

### Initialize and prepare to recieve notification

```swift
class ViewController: UIViewController, UIWebViewDelegate, JsNotyDelegate {
    private var jsNoty:JsNoty!;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.jsNoty = JsNoty(webView: self.webView)
        self.jsNoty.delegate = self
        
        let url = NSURL(string: "http://www.expample.com/path/to/page.html")
        let request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(self.jsNoty.receive(request)){
            return false;
        }
        
        return true
    }
```

### Notify to webView

```swift
self.jsNoty.notify("eventName");

//send json object
self.jsNoty.notify("eventNameWithJson", data: JSON(["foo": "bar"]));
```

## javascript side

You must call `JsNoty.nofify()` after window onload

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Document</title>
  <script src="/js/js-noty/JsNoty.js"></script>
  <script>
    JsNoty.on('eventName', function(e){
      //do somthing
    });
    JsNoty.on('secondFromSwift', function(e, data){
      //do somthing using data
    });
    
    window.onload = function(){
      JsNoty.nofify("noparams");
      JsNoty.nofify("second", {foo: "bar", integer: 1, arr: ["1", 2, "hoge"]});
    };

  </script>
</head>
<body>
  <h1>JsNoty Test</h1>
</body>
</html>
```
