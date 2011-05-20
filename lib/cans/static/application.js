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
      this.modules = _.map(returned.modules, function(m) {
        return new Module(m);
      });
      return this.view.trigger('loaded');
    };
    window.Module = function(_arg) {
      this.name = _arg;
      this.view = null;
      return this;
    };
    window.Module.prototype.load = function() {
      return Ajax("/class/" + (this.name), __bind(function(data) {
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
      return Ajax(this.url(), __bind(function(data) {
        return this.consume(data);
      }, this));
    };
    window.Method.prototype.consume = function(returned) {
      this.source = returned.source;
      return this.view.trigger('loaded');
    };
    window.Method.prototype.url = function() {
      return "/method/" + (escape(this.module.name)) + "/." + (escape(this.flavor)) + "/" + (escape(this.name));
    };
    window.Method.prototype.toJSON = function() {
      return {
        module: this.module.toJSON(),
        name: this.name,
        source: this.source,
        flavor: this.flavor,
        flavorSymbol: this.flavorSymbol
      };
    };
    window.InstanceMethod = function() {
      return window.Method.apply(this, arguments);
    };
    __extends(window.InstanceMethod, window.Method);
    window.InstanceMethod.prototype.flavor = 'i';
    window.InstanceMethod.prototype.flavorSymbol = '#';
    window.ClassMethod = function() {
      return window.Method.apply(this, arguments);
    };
    __extends(window.ClassMethod, window.Method);
    window.ClassMethod.prototype.flavor = 'm';
    window.ClassMethod.prototype.flavorSymbol = '::';
    window.SourceView = Backbone.View.extend({
      tagName: 'div',
      template: _.template($('#source_template').html()),
      render: function() {
        var rendered;
        rendered = this.template(this.model.toJSON());
        $(this.el).html(rendered);
        return this;
      }
    });
    window.MethodView = Backbone.View.extend({
      tagName: 'li',
      template: _.template($('#method_template').html()),
      events: {
        'click': 'loadSource'
      },
      initialize: function() {
        this.model.view = this;
        return this.bind('loaded', this.drawSource);
      },
      loadSource: function() {
        $('#content').html('');
        return this.model.load();
      },
      drawSource: function() {
        var sourceView;
        sourceView = new SourceView({
          model: this.model
        });
        $('#content').html(sourceView.render().el);
        return SyntaxHighlighter.highlight({}, $('#content pre')[0]);
      },
      render: function() {
        var rendered;
        rendered = this.template(this.model.toJSON());
        $(this.el).html(rendered);
        return this;
      }
    });
    window.ModuleView = Backbone.View.extend({
      tagName: 'li',
      template: _.template($('#module_template').html()),
      events: {
        'click': 'loadMethods'
      },
      initialize: function() {
        this.model.view = this;
        return this.bind('loaded', this.drawMethods);
      },
      loadMethods: function() {
        $('#class_method_list').html('');
        $('#instance_method_list').html('');
        $('#content').html('');
        return this.model.load();
      },
      drawMethods: function() {
        _(this.model.classMethods).each(function(m) {
          var view;
          view = new MethodView({
            model: m
          });
          return $('#class_method_list').append(view.render().el);
        });
        return _(this.model.localInstanceMethods).each(function(m) {
          var view;
          view = new MethodView({
            model: m
          });
          return $('#instance_method_list').append(view.render().el);
        });
      },
      render: function() {
        var rendered;
        rendered = this.template(this.model.toJSON());
        $(this.el).html(rendered);
        return this;
      }
    });
    window.MachineView = Backbone.View.extend({
      initialize: function() {
        this.model.view = this;
        return this.bind('loaded', this.drawModules);
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
    });
    return (window.App = new window.MachineView({
      model: new window.Machine()
    }));
  });
}).call(this);
