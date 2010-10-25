require 'helper'

class TestAddress < Test::Unit::TestCase
  context 'an Address to an instance method on the Beverage class' do
    setup do
      @address = Cans::Address.new 'Beverage/.i/refreshing'
    end
    subject { @address }

    should 'decode a module_name' do
      assert_equal 'Beverage', subject.module_name
    end

    should 'decode a method_kind' do
      assert_equal :instance, subject.method_kind
    end

    should 'decode a method_name' do
      assert_equal 'refreshing', subject.method_name
    end

    should 'find the target_module' do
      assert_equal Beverage, subject.target_module
    end
    
    should 'find the target_method' do
      assert_equal Beverage.instance_method(:refreshing), subject.target_method
    end
  end
end
