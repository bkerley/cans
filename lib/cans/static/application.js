(function() {
  var __bind = function(func, context) {
    return function(){ return func.apply(context, arguments); };
  }, __extends = function(child, parent) {
    var ctor = function(){};
    ctor.prototype = parent.prototype;
    child.prototype = new ctor();
    child.prototype.constructor = child;
    if (typeof parent.extended === "function") parent.extended(child);
    child.__super__ = parent.prototype;
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
      this.load();
      return this;
    };
    window.Machine.prototype.load = function() {
      return Ajax('/image', __bind(function(data) {
        return this.consume(data);
      }, this));
    };
    window.Machine.prototype.consume = function(returned) {
      return (this.modules = _.map(returned.modules, function(m) {
        return new Module(m);
      }));
    };
    window.CurrentMachine = new Machine();
    window.Module = function(_arg, _arg2) {
      this.name = _arg2;
      this.module = _arg;
      return this;
    };
    window.Module.prototype.load = function() {
      return Ajax("/module/" + (this.name), __bind(function(data) {
        return this.consume(data);
      }, this));
    };
    window.Module.prototype.consume = function(returned) {
      this.childModules = _.map(returned.child_modules, __bind(function(m) {
        return new Module(m);
      }, this));
      this.classMethods = _.map(returned.class_methods, __bind(function(m) {
        return new ClassMethod(this, m);
      }, this));
      this.localInstanceMethods = _.map(returned.local_instance_methods, __bind(function(m) {
        return new InstanceMethod(this, m);
      }, this));
      return (this.inheritedInstanceMethods = _.map(returned.inherited_instance_methods, __bind(function(m) {
        return new InstanceMethod(this, m);
      }, this)));
    };
    window.Method = function(_arg, _arg2) {
      this.name = _arg2;
      this.module = _arg;
      return this;
    };
    window.Method.prototype.load = function(flavor) {
      return Ajax("/" + (this.module.name) + "/." + (flavor) + "/" + (this.name), __bind(function(data) {
        return this.consume(data);
      }, this));
    };
    window.InstanceMethod = function() {
      return window.Method.apply(this, arguments);
    };
    __extends(window.InstanceMethod, window.Method);
    window.ClassMethod = function() {
      return window.Method.apply(this, arguments);
    };
    __extends(window.ClassMethod, window.Method);
    return window.ClassMethod;
  });
}).call(this);
