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
      fullPath = window.location.pathname + path;
      return jQuery.ajax({
        url: fullPath,
        success: callback
      });
    };
    window.Machine = function() {
      Ajax('/image', __bind(function(data) {
        return this.consume(data);
      }, this));
      return this;
    };
    window.Machine.prototype.consume = function(returned) {
      return (this.modules = _.map(returned.modules, function(m) {
        return new Module(m);
      }));
    };
    window.CurrentMachine = new Machine();
    window.Module = function(_arg) {
      this.name = _arg;
      return this;
    };
    return window.Module;
  });
}).call(this);
