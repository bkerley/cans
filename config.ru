require File.join(File.dirname(__FILE__), 'lib', 'cans.rb')
use Rack::ContentLength

run(Cans::Application.new)
