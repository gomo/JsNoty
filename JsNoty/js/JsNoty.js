;(function(){
  "use strict";
  var queue = [];
  var notifying = false;
  window.JsNoty = {
    notify : function(name, data){
      queue.push({name: name, data: data});
      if(!notifying){
        _sendNextRequest();
      }
    },
    on : function(name, callback){
      document.addEventListener(name, function(e){
        callback(e, e.detail);
      });
    }
  };
  function _sendNextRequest(){
    notifying = true;
    if(queue.length){
      var next = queue.pop();
      var url = 'jsnoty://' + next.name + '/' + (next.data ? jsonStringfy(next.data) : '');
      location.href = url;
    }
  };
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
            v = jQuery.stringify(v);
          }

          json.push((arr ? "" : '"' + n + '":') + String(v));
        }
      }

      return (arr ? "[" : "{") + String(json) + (arr ? "]" : "}");
    }
  };
  document.addEventListener("JsNotyRecieved", function(){
    notifying = false;
    _sendNextRequest();
  });
})();