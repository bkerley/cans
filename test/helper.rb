require 'rubygems'
require 'test/unit'
require 'rack/test'
require 'shoulda'
require 'mocha'

ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), 'fixtures', 'beverage')

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'cans'

class Test::Unit::TestCase
  include Rack::Test::Methods
end
