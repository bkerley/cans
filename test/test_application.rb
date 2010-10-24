require 'helper'

class TestApplication < Test::Unit::TestCase
  context 'an Application instance' do
    subject { app }

    context '#call method' do
      subject { app.method :call }

      should 'exist' do
        assert subject
      end

      should 'have an arity of 1' do
        assert_equal 1, subject.arity
      end
    end
  end

  def app
    Cans::Application.new
  end
end
