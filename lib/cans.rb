%w{ method_extensions sinatra/base haml }.each do |g|
  require g
end

%w{ address application }.each do |f|
  require File.join(File.dirname(__FILE__), 'cans', f)
end

module Cans

end
