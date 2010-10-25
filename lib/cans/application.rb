module Cans
  class Application < Sinatra::Base
      set :views, File.dirname(__FILE__) + '/views'

    get '/' do
      @constants = Object.constants
      @modules = @constants.map{ |c| Object.const_get c}.select{ |c| c.kind_of? Module}.sort_by(&:name)
      haml :index
    end

    get '/module/*' do
      @address = Address.new(params[:splat].first)
      @module = @address.target_module

      @local_instance_methods = @module.instance_methods false
      @all_instance_methods = @module.instance_methods true
      @super_instance_methods = @all_instance_methods - @local_instance_methods

      @class_methods = @module.methods

      @ancestors = @module.ancestors
      haml :module
    end

    get '/method/*' do
      @address = Address.new(params[:splat].first)
      @module = @address.target_module
      @method = @address.target_method
      haml :method
    end
  end
end
