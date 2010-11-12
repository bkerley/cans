module Cans
  class Historian
    attr_accessor :enabled
    def initialize
      try_history
    end

    def delve
      reload_history if enabled
    end

    private
    def reload_history
      ActiveSupport::Dependencies.history.each { |f| load f }
    end

    def try_history
      ActiveSupport::Dependencies.history
      enabled = true
    rescue
      enabled = false
    end
  end
end
