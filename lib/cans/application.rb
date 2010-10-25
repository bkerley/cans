module Cans
  class Application < Sinatra::Base
      set :views, File.dirname(__FILE__) + '/views'

    get '/' do
      'ok'
    end

    get '/method/*' do
      @address = Address.new(params[:splat].first)
      haml :method
    end
  end
end
