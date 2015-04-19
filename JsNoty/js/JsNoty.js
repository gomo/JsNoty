;(function($){
  "use strict";
  var queue = [];
  var notifying = false;
  var $document = $(document);
  window.JsNoty = {
    notify : function(name, data){
      queue.push({name: name, data: data});

      if(!notifying){
        _sendNextRequest();
      }
    }
  };
  function _sendNextRequest(){
    if(queue.length){
      notifying = true;
      var next = queue.pop();
      var url = 'jsnoty://' + next.name + '/' + (next.data ? jsonStringfy(next.data) : '');
      location.href = url;
    }
  };
  //https://gist.github.com/chicagoworks/754454
  function jsonStringfy(obj){
    if ("JSON" in window) {
      return JSON.stringify(obj);
    }
    var t = typeof (obj);
    if (t != "object" || obj === null) {
      // simple data type
      if (t == "string") obj = '"' + obj + '"';
      return String(obj);
    } else {
      // recurse array or object
      var n, v, json = [], arr = (obj && obj.constructor == Array);

      for (n in obj) {
        v = obj[n];
        t = typeof(v);
        if (obj.hasOwnProperty(n)) {
          if (t == "string") {
            v = '"' + v + '"';
          } else if (t == "object" && v !== null){
            v = jsonStringfy(v);
          }

          json.push((arr ? "" : '"' + n + '":') + String(v));
        }
      }

      return (arr ? "[" : "{") + String(json) + (arr ? "]" : "}");
    }
  };
  $document.on("JsNotyRecieved", function(){
    notifying = false;
    _sendNextRequest();
  });
})(jQuery);