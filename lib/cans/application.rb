module Cans
  class Application < Sinatra::Base
    set :views, File.dirname(__FILE__) + '/views'
    set :public, File.dirname(__FILE__) + '/static'

    get '/' do
      @constants = Object.constants
      @modules = @constants.map{ |c| Object.const_get c}.select{ |c| c.kind_of? Module}.sort_by(&:name)
      @history = @historian.history
      haml :index
    end

    get '/browser' do
      haml :frameset
    end

    post '/browser/r' do
      @constants = Object.constants
      @modules = @constants.map{ |c| Object.const_get c}.select{ |c| c.kind_of? Module}.map(&:name).sort
      content_type :json
      to_json({ :modules=>@modules })
    end

    get '/application.js' do
      coffee :application
    end

    get '/module/*' do
      @address = Address.new(params[:splat].first)
      @module = @address.target_module

      @local_instance_methods = @module.instance_methods false
      @all_instance_methods = @module.instance_methods true
      @super_instance_methods = @all_instance_methods - @local_instance_methods

      @class_methods = @module.methods

      @ancestors = @module.ancestors
      @child_modules = @module.constants.map{ |c| @module.const_get c}.select{ |c| c.kind_of? Module}.sort_by(&:name)

      haml :module
    end

    get '/method/*' do
      @address = Address.new(params[:splat].first)
      @module = @address.target_module
      @method = @address.target_method
      haml :method
    end

    def initialize
      @historian = Historian.new
      super
    end

    before do
      @historian.delve
    end

    helpers do
      def link(destination, content)
        prefix = request.env['rack.mount.prefix'] || ''
        href = prefix + destination
        "<a href='#{href}'>#{content}</a>"
      end

      def to_json(hash)
        JSON.generate hash
      end
    end
  end
end
