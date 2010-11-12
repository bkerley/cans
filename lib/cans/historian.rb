module Cans
  class Historian
    attr_accessor :enabled
    attr_accessor :history
    def initialize
      self.history = Set.new
      self.enabled = false
      try_history
      try_bugging_rails
    end

    def delve
      return unless enabled
      merge_history
      reload_history
    end

    def record
      merge_history
    end

    private
    def merge_history
      history.merge ActiveSupport::Dependencies.history
    end

    def reload_history
      history.each { |f| require_or_load f }
    end

    def try_history
      ActiveSupport::Dependencies.history
      self.enabled = true
    rescue
    end

    def try_bugging_rails
      this_historian = self
      ApplicationController.instance_eval do
        after_filter :save_history
        define_method :save_history do
          this_historian.record
        end
      end
      self.enabled = true
    rescue => e
    end
  end
end
