module Cans
  class Address
    METHOD_KIND_REGEX = %r{\.(.)}
    MODULE_NAME_REGEX = /^(.+)\/\.|^(.+)$/
    METHOD_NAME_REGEX = %r{\../(.+)$}

    def initialize(address_string)
      @string = address_string
    end

    def module_name
      md = MODULE_NAME_REGEX.match @string
      raise "No module_name found in #{@string.inspect}" unless md
      return md.captures.detect{ |m| !(m.nil? || m.empty?) }.gsub('/','::')
    end

    def method_kind
      md = METHOD_KIND_REGEX.match @string
      raise "No method_kind found" unless md
      return case md[1]
             when 'i'
               :instance
             when 'm'
               :module
             else
               raise 'Unexpected method_kind found'
             end
    end

    def method_name
      md = METHOD_NAME_REGEX.match @string
      raise 'No method_name found' unless md
      return md[1].gsub('/','')
    end

    def target_module
      eval "::#{module_name}"
    end

    def target_method
      case method_kind
      when :instance
        target_module.instance_method method_name
      when :module
        target_module.method method_name
      end
    end
  end
end
