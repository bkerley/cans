require 'helper'

class TestApplication < Test::Unit::TestCase
  context 'an Application instance' do
    subject { app.new }

    context '#call method' do
      subject { app.new.method :call }

      should 'exist' do
        assert subject
      end

      should 'have an arity of 1' do
        assert_equal 1, subject.arity
      end
    end
  end

  context 'get to /' do
    setup do
      get '/'
    end

    should 'be ok' do
      assert last_response.ok?
    end

    should 'list some known modules' do
      expected_constants = %w{ Cans Beverage TestApplication }

      expected_constants.each do |c|
        assert_match c, last_response.body
      end
    end
  end

  context 'get to /method/Beverage/.i/refreshing' do
    setup do
      get '/method/Beverage/.i/refreshing'
    end

    should 'be ok' do
      assert last_response.ok?
    end

    should 'include the source' do
      assert_match /quite/, last_response.body
    end
  end

  context 'get to /module/Beverage' do
    setup do
      get '/module/Beverage'
    end

    should 'be ok' do
      assert last_response.ok?
    end

    should 'include the "refreshing" instance method' do
      assert_match /refreshing/, last_response.body
    end
  end

  def app
    Cans::Application
  end
end
