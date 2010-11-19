(function() {
  var __bind = function(func, context) {
    return function(){ return func.apply(context, arguments); };
  };
  jQuery(function() {
    var Ajax;
    jQuery.ajaxSetup({
      type: 'post',
      dataType: 'json'
    });
    Ajax = function(path, callback) {
      var fullPath;
      fullPath = window.location.pathname + '/browser' + path;
      return jQuery.ajax({
        url: fullPath,
        success: callback
      });
    };
    window.Machine = function() {
      Ajax('/image', __bind(function(data) {}, this));
      return this;
    };
    window.Machine.prototype.consume = 0;
    return window.Machine;
  });
}).call(this);
