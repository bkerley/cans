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
    window.Machine = function(_arg) {
      this.machineView = _arg;
      this.load();
      return this;
    };
    window.Machine.prototype.load = function() {
      return Ajax('/image', __bind(function(data) {
        return this.consume(data);
      }, this));
    };
    window.Machine.prototype.consume = function(returned) {
      this.modules = _.map(returned.modules, function(m) {
        return new Module(m);
      });
      return this.machineView.trigger('loaded');
    };
    window.Module = function(_arg) {
      this.name = _arg;
      this.view = null;
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
      this.inheritedInstanceMethods = _.map(returned.inherited_instance_methods, __bind(function(m) {
        return new InstanceMethod(this, m);
      }, this));
      return this.view.trigger('loaded');
    };
    window.Module.prototype.toJSON = function() {
      return {
        name: this.name
      };
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
    window.MachineView = {
      start: function() {
        _.extend(this, Backbone.Events);
        this.bind('loaded', this.drawModules);
        return (this.model = new window.Machine(this));
      },
      drawModules: function() {
        return _(this.model.modules).each(function(m) {
          var view;
          view = new ModuleView({
            model: m
          });
          return $('#module_list').append(view.render().el);
        });
      }
    };
    window.ModuleView = Backbone.View.extend({
      tagName: 'li',
      template: _.template($('#module_template').html()),
      events: {
        'click a': 'loadMethods',
        'loaded': 'drawMethods'
      },
      initialize: function() {
        return (this.model.view = this);
      },
      loadMethods: function() {
        return this.model.load();
      },
      drawMethods: function() {
        return this.model.localInstanceMethods.each(function(m) {
          return $('#method_list').append(m.name);
        });
      },
      render: function() {
        var rendered;
        rendered = this.template(this.model.toJSON());
        $(this.el).html(rendered);
        return this;
      }
    });
    return window.MachineView.start();
  });
}).call(this);
