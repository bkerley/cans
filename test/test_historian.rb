require 'helper'

class TestHistorian < Test::Unit::TestCase
  context 'a Historian' do
    setup do
      @historian = Cans::Historian.new
    end

    subject { @historian }

    should "not be enabled since AS isn't loaded" do
      assert !subject.enabled
    end
  end
end
